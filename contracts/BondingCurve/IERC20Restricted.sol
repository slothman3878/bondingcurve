//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @title IERC20Restricted
/// @author Do Yun Kim
/// @dev Functions need modifier restricting access
/// @notice ERC20 with restricted access to minting and burning
interface IERC20Restricted is IERC20 {
  function mint(address account, uint256 amount) external;
  function burn(address account, uint256 amount) external;
}