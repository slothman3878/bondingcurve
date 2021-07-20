//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface IBondingCurve {
  // returns price at current supply
  function price() external view returns (uint256);
}