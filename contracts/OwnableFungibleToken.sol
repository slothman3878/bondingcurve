//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// A Continuous Token (CT) is a AutonomousTrust (DAT) and OwnableFungibleToken (OFT) Pair
contract OwnableFungibleToken is Context, Ownable, ERC20 {
  // The "Ownable" tag is more for convenience, so that the minting and burning of tokens can
  // only be triggered by a single entity.
  constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) {}

  function mint(address account, uint256 amount) external virtual onlyOwner {
    _mint(account, amount);
  }

  function burn(address account, uint256 amount) external virtual onlyOwner {
    _burn(account, amount);
  }
}