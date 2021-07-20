//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../BancorContinuousToken.sol";

/** Two Bonding Curves: Mint Curve and Burn Curve
    Mint Price >= Burn Price always */

abstract contract ScalarRBCT is Context, Ownable, BancorContinuousToken{
  using SafeMath for uint256;

  uint32 private _m2r; // Mint and Retire Ratio

  constructor(
    string memory name_,
    string memory symbol_,
    uint32 cw_,
    uint32 m2r_
  ) BancorContinuousToken(name_, symbol_, cw_)
  {
    _m2r = m2r_;
  }

  function price() public view virtual override initialized returns (uint256) {
    return BancorContinuousToken.price().mul(_m2r);
  }

  function mint(uint256 amount) external payable virtual override {
    require(msg.value == purchaseCost(amount), "Incorrect Deposit for Given Amount");
    (bool sent, ) = payable(owner()).call{
      value: msg.value - BancorContinuousToken.purchaseCost(amount)
    }("");
    require(sent, "Failed ETH transfer");
    _token.mint(_msgSender(), amount);
  }

  function mint() external payable virtual override {
    _token.mint(
      _msgSender(),
      BancorContinuousToken.purchaseTargetAmount(msg.value.div(_m2r))
    );
    (bool sent, ) = payable(owner()).call{
      value: msg.value.sub(msg.value.div(_m2r))
    }("");
    require(sent, "Failed ETH transfer");
  }

  // Cost of purchasing "amount" of cont. tokens
  function purchaseCost(uint256 amount) public view virtual override initialized returns (uint256) {
    return _formula.purchaseCost(
      totalSupply(),
      address(this).balance,
      reserveWeight(),
      amount
    ).mul(_m2r);
  }

  // Cont. token gains from depositing "amount" of reserve tokens
  function purchaseTargetAmount(uint256 amount) public view virtual override initialized returns (uint256) {
    return _formula.purchaseTargetAmount(
      totalSupply(),
      address(this).balance,
      reserveWeight(),
      amount/_m2r
    ).mul(_m2r);
  }
}