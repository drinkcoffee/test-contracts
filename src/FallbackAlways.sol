// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


contract FallbackAlways {
    event FallbackCalled(address sender);

    fallback() external {
        emit FallbackCalled(msg.sender);
    }
}
