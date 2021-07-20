//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface IBondingCurve {
  // returns price at current supply
  function price() public view virtual returns (uint256);
}