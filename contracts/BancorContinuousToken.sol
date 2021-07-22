//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "./ContinuousToken.sol";
import "./utils/BancorFormula.sol";

abstract contract BancorContinuousToken is Context, ContinuousToken{
  using SafeMath for uint256;

  uint32 private immutable _cw;
  bool private _initialized;
  // Power functions equations and hence the Bancor Formula requires external initialization.
  // Power and Bancor Formula is essentially a library with state variables, and shouldn't be payable in theory.
  BancorFormula internal _formula;

  event Initialize(uint32 reserveWeight, uint256 initialSupply, uint256 initialReserve);

  constructor(
    string memory name_,
    string memory symbol_,
    uint32 cw_
  ) ContinuousToken(name_, symbol_)
  {
    _cw = cw_;
    _formula = new BancorFormula();
  }

  modifier initialized {
    require(_initialized, "Token is not Initialized");
    _;
  }

  // Adjusting Reserve Weight
  /** receive() external payable {
    _cw = _recalculateCW();
  } */

  // Initialize with non-zero supply and reserve
  // Need to initialize after constructor
  function init() public virtual payable {
    require(!_initialized);
    require(msg.value > 0, "Initial Reserve Balance Cannot be Zero");
    _token.mint(address(0),1);
    _formula.init();
    _initialized = true;
    emit Initialize(reserveWeight(),1,address(this).balance);
  }

  function reserveWeight() public view virtual returns (uint32) {
    return _cw;
  }

  function price() public view virtual override initialized returns (uint256) {
    return address(this).balance / (totalSupply().mul(reserveWeight()/1000000));
  }

  // Cost of purchasing "amount" of cont. tokens
  function purchaseCost(uint256 amount) public view virtual override initialized returns (uint256) {
    return _formula.purchaseCost(
      totalSupply(),
      address(this).balance,
      reserveWeight(),
      amount
    );
  }

  // Cont. token gains from depositing "amount" of reserve tokens
  function purchaseTargetAmount(uint256 amount) public view virtual override initialized returns (uint256) {
    return _formula.purchaseTargetAmount(
      totalSupply(),
      address(this).balance,
      reserveWeight(),
      amount
    );
  }

  // Reserve token gains from liquidating "amount" of cont. tokens
  function saleTargetAmount(uint256 amount) public view virtual override initialized returns (uint256) {
    return _formula.purchaseTargetAmount(
      totalSupply(),
      address(this).balance,
      reserveWeight(),
      amount
    );
  }

  // Recalcuate CW after deposit
  /** function _recalculateCW() internal view virtual initialized returns (uint32) {
    uint256 p_0 = price();
    return uint32(address(this).balance/(p_0.mul(totalSupply())).mul(1000000));
  } */
}