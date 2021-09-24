//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "./ERC20Restricted.sol";

/// @title ContinuousToken
/// @author Do Yun Kim
/// @notice Abstract contract for implementing continuous tokens
/// @dev Wraps ERC20Restricted
/**
 * Note 'payable' declaration is only necessary if the reserve token is in Ether.
 * Declared as 'payable' in case Ether as reserve token is allowed.
 */
abstract contract ContinuousToken is Context {
  /// @notice Token address
  /// @dev Should be immutable in theory
  address private _token;

  /// @notice initialize token
  /// @dev use this instead of constructor for cheaper on-chain computation
  function init(string memory name_, string memory symbol_, uint8 decimals_) public virtual {
    _token = address(new ERC20Restricted(name_, symbol_, decimals_));
  }

  /// @notice token address
  function token() public view virtual returns (address) {
    return _token;
  }

  /// @notice total supply of tokens
  /// @dev calls totalSupply in token contract
  function totalSupply() public view returns (uint256) {
    return IERC20(_token).totalSupply();
  }

  /// @notice balance of given account
  /// @dev calls balanceOf in token contract
  function balanceOf(address account) public view returns (uint256) {
    return IERC20(_token).balanceOf(account);
  } 

  /// @notice name of token
  /// @dev calls name in token contract
  function name() public view returns (string memory) {
    return IERC20Metadata(_token).name();
  }

  /// @notice symbol of token
  /// @dev calls symbol in token contract
  function symbol() public view returns (string memory) {
    return IERC20Metadata(_token).symbol();
  }

  /// @notice decimals of token
  /// @dev calls decimals in token contract
  function decimals() public view returns (uint8) {
    return IERC20Metadata(_token).decimals();
  }

  /// @notice Returns price at current supply
  /// @dev should be calling some function that simulates a bonding curve
  function price() public view virtual returns (uint256) {}

  /*
  /// @notice Mints tokens pertaining to the deposited amount of reserve tokens
  /// @dev Calls mint on token contract
  /// @param deposit The deposited amount of reserve tokens
  function mint(uint256 deposit) external payable virtual {}
  
  /// @notice Retires tokens of given amount
  /// @dev Calls burn on token contract
  /// @param amount The amount of tokens being retired
  function retire(uint256 amount) external payable virtual {}*/

  /// @notice Cost of purchasing given amount of tokens
  /// @param amount The amount of tokens to be purchased
  function purchaseCost(uint256 amount) public view virtual returns (uint256) {}

  /// @notice Tokens that will be minted for a given deposit
  /// @param deposit The deposited amount of reserve tokens
  function purchaseTargetAmount(uint256 deposit) public view virtual returns (uint256) {}

  /// @notice Amount in reserve tokens from retiring given amount of cont. tokens
  /// @param amount The amount of tokens to be retired
  function saleTargetAmount(uint256 amount) public view virtual returns (uint256) {}
}