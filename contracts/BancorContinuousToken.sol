// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./BondingCurve/ContinuousToken.sol";
import "./BancorFormula/BancorFormula.sol";
import "./libraries/TransferHelper.sol";

/// @title BancorContinuousToken
contract BancorContinuousToken is Context, ContinuousToken {
  using SafeMath for uint256;

  /// BancorFormula contract address
  address internal immutable _formula;
  // Reserve token. Should be a stable coin. For convenience, we'll assume USDC
  // Theoretically, should be immutable, but need to factor in coin contract updates.
  address internal r_token;

  // Reserve Weight
  uint32 internal immutable _cw;

  bool private _initialized = false;

  event Mint(
    address indexed by,
    uint256 amount
  );

  event Retire(
    address indexed by,
    uint256 amount,
    uint256 liquidity
  );

  constructor(uint32 cw_, address formula_, address r_token_) {
    _cw = cw_; _formula = formula_; r_token = r_token_;
  }

  modifier initialized {
    require(_initialized, "BancorContinuousToken: Token is not Initialized");
    _;
  }

  /// @notice initialize token with non-zero but negligible supply and reserve
  /// @dev Initializes Bancor formula contract. Mints single token. Can only be called if token hasn't been initialized.
  /// Note Must call after construction, and before calling any other functions
  function init(string memory name_, string memory symbol_) public virtual payable {
    require(!_initialized);
    super.init(name_, symbol_, 18);
    IERC20Restricted(token()).mint(address(this),1e18); // non-zero, but virtually negligible
    BancorFormula(_formula).init();
    _initialized = true;
  }

  /// @notice Returns reserve balance
  /// @dev calls balanceOf in reserve token contract
  /**
   *  Note Reserve Balance, precision = 6
   *  Reserve balance will be zero initially, but in theory should be 1 reserve token.
   *  We can assume the contract has 1USDC initially, since it cannot be withdrawn anyway.
   */
  function reserveBalance() public view virtual returns (uint256) {
    (bool success, bytes memory data) =
      r_token.staticcall(abi.encodeWithSelector(IERC20.balanceOf.selector, address(this)));
    require(success && data.length >= 32, "Reserve Token Balance Check Failure"); /// This is just for safety. Ideally, this requirement shouldn't fail in any circumstance.
    return abi.decode(data, (uint256))+1e6;
  }

  function reserveWeight() public view virtual returns (uint32) {
    return _cw;
  }

  /// @notice Returns price at current supply
  /// @dev price = reserve_balance / (reserve_weight * total_supply)
  function price() public view virtual override initialized returns (uint256) {
    return (address(this).balance.div(totalSupply())).mul(1000000/reserveWeight());
  }

  /// @notice Mints tokens pertaining to the deposited amount of reserve tokens
  /// @dev Calls mint on token contract, purchaseTargetAmount on formula contract
  /// @param deposit The deposited amount of reserve tokens
  /// Note Must approve with reserve token before calling
  function mint(uint256 deposit) external payable virtual {
    uint256 amount = BancorFormula(_formula).purchaseTargetAmount(
      totalSupply(),
      reserveBalance(),
      reserveWeight(),
      deposit
    );
    IERC20Restricted(token()).mint(_msgSender(), amount);
    // Add `try / catch` statement for smoother error handling
    TransferHelper.safeTransferFrom(r_token, _msgSender(), address(this), deposit);
    emit Mint(_msgSender(), amount);
  }

  /// @notice Retires tokens of given amount, and transfers pertaining reserve tokens to account
  /// @dev Calls burn on token contract, saleTargetAmmount on formula contract
  /// @param amount The amount of tokens being retired
  function retire(uint256 amount) external payable virtual {
    require(totalSupply()-amount>0, "BancorContinuousToken: Requested Retire Amount Exceeds Supply");
    require(amount <= balanceOf(_msgSender()), "BancorContinuousToken: Requested Retire Amount Exceeds Owned");
    uint256 liquidity = BancorFormula(_formula).saleTargetAmount(
      totalSupply(),
      reserveBalance(),
      reserveWeight(),
      amount
    );
    TransferHelper.safeTransfer(r_token, _msgSender(), liquidity);
    IERC20Restricted(token()).burn(_msgSender(), amount);
    emit Retire(_msgSender(), amount, liquidity);
  }

  /// @notice Cost of purchasing given amount of tokens
  /// @dev Calls purchaseCost on formula contract
  /// @param amount The amount of tokens to be purchased
  function purchaseCost(uint256 amount) public view virtual override initialized returns (uint256) {
    return BancorFormula(_formula).purchaseCost(
      totalSupply(),
      reserveBalance(),
      reserveWeight(),
      amount
    );
  }

  /// @notice Tokens that will be minted for a given deposit
  /// @dev Calls purchaseTargetAmount on formula contract
  /// @param deposit The deposited amount of reserve tokens
  function purchaseTargetAmount(uint256 deposit) public view virtual override initialized returns (uint256) {
    return BancorFormula(_formula).purchaseTargetAmount(
      totalSupply(),
      reserveBalance(),
      reserveWeight(),
      deposit
    );
  }

  /// @notice Amount in reserve tokens from retiring given amount of cont. tokens
  /// @dev Calls saleTargetAmount on formula contract
  /// @param amount The amount of tokens to be retired
  function saleTargetAmount(uint256 amount) public view virtual override initialized returns (uint256) {
    require(totalSupply()-amount>0, "BancorContinuousToken: Requested Retire Amount Exceeds Supply");
    return BancorFormula(_formula).saleTargetAmount(
      totalSupply(),
      reserveBalance(),
      reserveWeight(),
      amount
    );
  }

  /// @notice Changes reserve token address in case it is updated
  /// NOTE need better implementation. Adding an admin account seems the best option.
  function setReserveToken(address _r_token) external virtual  {
    r_token = _r_token;
  }
}