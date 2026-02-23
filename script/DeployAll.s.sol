// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19 <0.8.29;

import "forge-std/Script.sol";
import {FallbackNFT} from "../src/FallbackNFT.sol";
import {FallbackERC20} from "../src/FallbackERC20.sol";
import {FallbackAlways} from "../src/FallBackAlways.sol";

/**
 * @notice Deploys FallbackNFT, FallbackERC20, and FallbackAlways.
 * @dev Set constructor args via env vars; see run() for names. Optional vars use defaults.
 */
contract DeployAll is Script {
    function run() external {
        address deployer = vm.envAddress("DEPLOYER_ADDRESS");

        vm.startBroadcast(deployer);

        // 1. FallbackAlways (no constructor args)
        FallbackAlways fallbackAlways = new FallbackAlways();
        console.log("FallbackAlways deployed at", address(fallbackAlways));

        // 2. FallbackERC20
        string memory erc20Name = vm.envOr("ERC20_NAME", string("Fallback Token"));
        string memory erc20Symbol = vm.envOr("ERC20_SYMBOL", string("FBACK"));
        uint256 erc20Supply = vm.envOr("ERC20_TOTAL_SUPPLY", uint256(1_000_000 * 10**18));
        address erc20Treasurer = vm.envOr("ERC20_TREASURER", deployer);
        address erc20HubOwner = vm.envOr("ERC20_HUB_OWNER", deployer);
        FallbackERC20 fallbackErc20 = new FallbackERC20(erc20Name, erc20Symbol, erc20Supply, erc20Treasurer, erc20HubOwner);
        console.log("FallbackERC20 deployed at", address(fallbackErc20));

        // 3. FallbackNFT
        address nftOwner = vm.envOr("NFT_OWNER", deployer);
        string memory nftName = vm.envOr("NFT_NAME", string("Fallback NFT"));
        string memory nftSymbol = vm.envOr("NFT_SYMBOL", string("FNFT"));
        string memory nftBaseUri = vm.envOr("NFT_BASE_URI", string("https://api.example.com/metadata/"));
        string memory nftContractUri = vm.envOr("NFT_CONTRACT_URI", string("https://api.example.com/contract"));
        address nftOperatorAllowlist = vm.envOr("NFT_OPERATOR_ALLOWLIST", address(0));
        address nftRoyaltyReceiver = vm.envOr("NFT_ROYALTY_RECEIVER", deployer);
        uint96 nftFeeNumerator = uint96(vm.envOr("NFT_FEE_NUMERATOR", uint256(500))); // 5%
        FallbackNFT fallbackNft = new FallbackNFT(
            nftOwner,
            nftName,
            nftSymbol,
            nftBaseUri,
            nftContractUri,
            nftOperatorAllowlist,
            nftRoyaltyReceiver,
            nftFeeNumerator
        );
        console.log("FallbackNFT deployed at", address(fallbackNft));

        vm.stopBroadcast();
    }
}
