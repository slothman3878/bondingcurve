//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// A Continuous Token (CT) is a AutonomousTrust (DAT) and OwnableFungibleToken (OFT) Pair
contract OwnableFungibleToken is Context, Ownable, ERC20 {
  // The "Ownable" tag is more for convenience, so that the minting and burning of tokens can
  // only be triggered by a single entity.
  uint8 private _decimals;

  constructor(string memory name_, string memory symbol_, uint8 decimals_) ERC20(name_, symbol_) {
    _decimals = decimals_;
  }

  function mint(address account, uint256 amount) external virtual onlyOwner {
    _mint(account, amount);
  }

  function burn(address account, uint256 amount) external virtual onlyOwner {
    _burn(account, amount);
  }

  function decimals() public view virtual override returns (uint8) {
    return _decimals;
  }
}