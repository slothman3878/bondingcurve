// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title SimpleToken
/// @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator
/// @notice simple fungible token as test reserve token
contract SimpleToken is ERC20('SimpleToken', 'SIMP') {

  /// @notice mints given amount of tokens for msg.sender
  function mint(uint256 amount) public {
    _mint(msg.sender, amount);
  }

  function decimals() public pure override returns (uint8) {
    return 6;
  }
}