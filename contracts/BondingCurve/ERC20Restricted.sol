//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./IERC20Restricted.sol";

/// @title ERC20Restricted
/// @author Do Yun Kim
contract ERC20Restricted is Context, Ownable, ERC20, IERC20Restricted {
  uint8 private immutable _decimals;

  constructor(string memory name_, string memory symbol_, uint8 decimals_) ERC20(name_, symbol_) {
    _decimals = decimals_;
  }

  /// @notice mints given amount of tokens in given account
  /// @dev Calls _mint function in ERC20. Can only be called by owner of Ownable  
  /// @param account address where tokens will be added
  /// @param amount amount of tokens to be minted
  function mint(address account, uint256 amount) external override virtual onlyOwner {
    _mint(account, amount);
  }

  /// @notice burns given amount of tokens in given account
  /// @dev Calls _burn function in ERC20. Can only be called by owner of Ownable
  /// @param account address whose tokens will be burnt
  /// @param amount amount of tokens to be burnt
  function burn(address account, uint256 amount) external override virtual onlyOwner {
    _burn(account, amount);
  }

  /// @notice returnss precision decimal of token
  function decimals() public view virtual override returns (uint8) {
    return _decimals;
  }
}