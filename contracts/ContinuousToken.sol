//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Context.sol";
import "./interface/IBondingCurve.sol";
import "./OwnableFungibleToken.sol";

abstract contract ContinuousToken is Context, IBondingCurve{
  OwnableFungibleToken public _token;
  constructor(
    // Token Constructor
    string memory name_,
    string memory symbol_
  )
  payable {
    // Add to reserve the amount pertaining to initial supply and reserve
    _token = new OwnableFungibleToken(name_, symbol_);
  }

  function name() public view virtual returns (string memory) {
    return _token.name();
  }

  function symbol() public view virtual returns (string memory) {
    return _token.symbol();
  }

  function totalSupply() public view virtual returns (uint256) {
    return _token.totalSupply();
  }

  // returns price at current supply
  function price() public view virtual returns (uint256);

  function mint(uint256 amount) external payable virtual {
    require(msg.value == purchaseCost(amount));
    _token.mint(_msgSender(), amount);
  }

  function mint() external payable virtual {
    _token.mint(_msgSender(), purchaseTargetAmount(msg.value));
  }
  
  function retire(uint256 amount) external payable virtual {
    require(_token.balanceOf(_msgSender()) >= amount);
    (bool sent, ) = payable(_msgSender()).call{value: saleTargetAmount(amount)}("");
    require(sent);
    _token.burn(_msgSender(), amount);
  }

  // Cost of purchasing "amount" of cont. tokens
  function purchaseCost(uint256 amount) public view virtual returns (uint256);

  // Cont. token gains from depositing "amount" of reserve tokens
  function purchaseTargetAmount(uint256 amount) public view virtual returns (uint256);

  // Reserve token gains from retiring "amount" of cont. tokens
  function saleTargetAmount(uint256 amount) public view virtual returns (uint256);
}