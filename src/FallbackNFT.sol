// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19 <0.8.29;

import {ImmutableERC721MintByID} from "contracts/token/erc721/preset/ImmutableERC721MintByID.sol";

/**
 * @notice ERC721 that extends Immutable's ImmutableERC721MintByID preset and emits an event when the fallback is called.
 */
contract FallbackNFT is ImmutableERC721MintByID {
    event FallbackCalled(address sender);

    /**
     * @param owner_ The address to grant the DEFAULT_ADMIN_ROLE to
     * @param name_ The name of the collection
     * @param symbol_ The symbol of the collection
     * @param baseURI_ The base URI for the collection
     * @param contractURI_ The contract URI for the collection
     * @param operatorAllowlist_ The address of the operator allowlist
     * @param royaltyReceiver_ The address of the royalty receiver
     * @param feeNumerator_ The royalty fee numerator (basis points)
     */
    // forge-lint: disable-next-item(mixed-case-variable)
    constructor(
        address owner_,
        string memory name_,
        string memory symbol_,
        string memory baseURI_,
        string memory contractURI_,
        address operatorAllowlist_,
        address royaltyReceiver_,
        uint96 feeNumerator_
    ) ImmutableERC721MintByID(owner_, name_, symbol_, baseURI_, contractURI_, operatorAllowlist_, royaltyReceiver_, feeNumerator_) {}

    fallback() external {
        emit FallbackCalled(msg.sender);
    }
}
