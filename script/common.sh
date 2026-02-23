#!/bin/bash

# Run from project root (directory that contains script/)
cd "$(dirname "$0")/.." || exit 1

# Load the .env file if it exists
if [ -f .env ]; then
    set -a; source .env; set +a
fi

if [ -z "${IMMUTABLE_NETWORK}" ]; then
    echo "Error: IMMUTABLE_NETWORK variable is not set (use 1 for mainnet, 0 for testnet)"
    exit 1
fi
if [[ $IMMUTABLE_NETWORK -eq 1 ]]; then
    echo "Immutable zkEVM Mainnet Configuration"
    IMMUTABLE_RPC=https://rpc.immutable.com
    BLOCKSCOUT_URI=https://explorer.immutable.com/api?
    export NFT_OPERATOR_ALLOWLIST=0x5F5EBa8133f68ea22D712b0926e2803E78D89221
else
    echo "Immutable zkEVM Testnet Configuration"
    IMMUTABLE_RPC=https://rpc.testnet.immutable.com
    BLOCKSCOUT_URI=https://explorer.testnet.immutable.com/api?
    export NFT_OPERATOR_ALLOWLIST=0x6b969FD89dE634d8DE3271EbE97734FEFfcd58eE
fi
if [ -z "${BLOCKSCOUT_APIKEY}" ]; then
    echo "Error: BLOCKSCOUT_APIKEY environment variable is not set"
    exit 1
fi

if [ -z "${DEPLOYER_ADDRESS}" ]; then
    echo "Error: DEPLOYER_ADDRESS variable is not set"
    exit 1
fi

if [ -z "${FUNCTION_TO_EXECUTE}" ]; then
    echo "Error: FUNCTION_TO_EXECUTE variable is not set"
    exit 1
fi

script=script/DeployAll.s.sol:DeployAll

echo "Configuration"
echo " IMMUTABLE_RPC: $IMMUTABLE_RPC"
echo " BLOCKSCOUT_URI: $BLOCKSCOUT_URI"
echo " BLOCKSCOUT_APIKEY: $BLOCKSCOUT_APIKEY"
echo " DEPLOYER_ADDRESS: $DEPLOYER_ADDRESS"
echo " Function to execute: $FUNCTION_TO_EXECUTE"
echo " Script: $script"

if [ -n "${PRIVATE_KEY}" ]; then
    echo " Signing: private key"
    forge script --rpc-url "$IMMUTABLE_RPC" \
        --optimize \
        --optimizer-runs 1 \
        --priority-gas-price 10000000000 \
        --with-gas-price 10000000100 \
        -vvv \
        --broadcast \
        --verify \
        --verifier blockscout \
        --verifier-url "$BLOCKSCOUT_URI$BLOCKSCOUT_APIKEY" \
        --sig "$FUNCTION_TO_EXECUTE" \
        --private-key "$PRIVATE_KEY" \
        $script
else
    echo " Error: PRIVATE_KEY environment variable is not set"
    exit 1
fi
