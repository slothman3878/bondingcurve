//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title IBondingCurve
/// @author Do Yun Kim
/// @notice Bonding Curve interface for modularization purposes
interface IBondingCurve {
  /// @notice returns price at current supply
  function price() external view returns (uint256);
}