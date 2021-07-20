//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ContinuousToken.sol";
import "./utils/BancorFormula.sol";

abstract contract BancorContinuousToken is Context, ContinuousToken, BancorFormula{
  using SafeMath for uint256;

  uint32 private _cw;

  constructor(
    string memory name_,
    string memory symbol_,
    uint32 cw_
  ) ContinuousToken(name_, symbol_)
  payable {
    _cw = cw_;
  }

  // Deposits that do not return minted tokens will alter the reserve weight
  receive() external payable {
    _cw = _recalculateCW();
  }

  function reserveWeight() public view virtual returns (uint32) {
    return _cw;
  }

  function price() public view virtual override returns (uint256) {
    return address(this).balance / (totalSupply().mul(reserveWeight()/1000000));
  }

  // Cost of purchasing "amount" of cont. tokens
  function purchaseCost(uint256 amount) public view virtual override returns (uint256) {
    return BancorFormula.purchaseCost(
      totalSupply(),
      address(this).balance,
      reserveWeight(),
      amount
    );
  }

  // Cont. token gains from depositing "amount" of reserve tokens
  function purchaseTargetAmount(uint256 amount) public view virtual override returns (uint256) {
    return BancorFormula.purchaseTargetAmount(
      totalSupply(),
      address(this).balance,
      reserveWeight(),
      amount
    );
  }

  // Reserve token gains from retiring "amount" of cont. tokens
  function saleTargetAmount(uint256 amount) public view virtual override returns (uint256) {
    return BancorFormula.purchaseTargetAmount(
      totalSupply(),
      address(this).balance,
      reserveWeight(),
      amount
    );
  }

  // Recalcuate CW after deposit
  function _recalculateCW() internal view virtual returns (uint32) {
    uint256 p_0 = price();
    return uint32(address(this).balance/(p_0.mul(totalSupply())).mul(1000000));
  }
}