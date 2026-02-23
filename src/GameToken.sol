// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19 <0.8.29;

import {ImmutableERC20FixedSupplyNoBurn} from "contracts/token/erc20/preset/ImmutableERC20FixedSupplyNoBurn.sol";

/**
 * @notice ERC20 that extends Immutable's fixed-supply preset and emits an event when the fallback is called.
 */
contract GameToken is ImmutableERC20FixedSupplyNoBurn {
    event FallbackCalled(address sender);

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _totalSupply,
        address _treasurer,
        address _hubOwner
    ) ImmutableERC20FixedSupplyNoBurn(_name, _symbol, _totalSupply, _treasurer, _hubOwner) {}

    fallback() external {
        emit FallbackCalled(msg.sender);
    }
}
