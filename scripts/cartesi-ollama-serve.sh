#!/bin/sh

set -e

INPUT=0x6e6f687570202e2f6f6c6c616d61207365727665203e202f746d702f6f6c6c616d612e6c6f6720323e26312026; \
INPUT_BOX_ADDRESS=0x59b22D57D4f067708AB0c00552767405926dc768; \
APPLICATION_ADDRESS=0xab7528bb862fB57E8A2BCd567a2e929a0Be56a5e; \
cast send \
    --mnemonic "test test test test test test test test test test test junk" \
    --rpc-url "http://localhost:8545" \
    $INPUT_BOX_ADDRESS "addInput(address,bytes)(bytes32)" $APPLICATION_ADDRESS $INPUT


echo "sleep 10"
INPUT=0x736c656570203130; \
INPUT_BOX_ADDRESS=0x59b22D57D4f067708AB0c00552767405926dc768; \
APPLICATION_ADDRESS=0xab7528bb862fB57E8A2BCd567a2e929a0Be56a5e; \
cast send \
    --mnemonic "test test test test test test test test test test test junk" \
    --rpc-url "http://localhost:8545" \
    $INPUT_BOX_ADDRESS "addInput(address,bytes)(bytes32)" $APPLICATION_ADDRESS $INPUT


echo "curl version"
INPUT=0x6375726c20687474703a2f2f3132372e302e302e313a31313433342f6170692f76657273696f6e; \
INPUT_BOX_ADDRESS=0x59b22D57D4f067708AB0c00552767405926dc768; \
APPLICATION_ADDRESS=0xab7528bb862fB57E8A2BCd567a2e929a0Be56a5e; \
cast send \
    --mnemonic "test test test test test test test test test test test junk" \
    --rpc-url "http://localhost:8545" \
    $INPUT_BOX_ADDRESS "addInput(address,bytes)(bytes32)" $APPLICATION_ADDRESS $INPUT

echo "cat log"
curl http://localhost:8080/inspect/cat%20%2Ftmp%2Follama.log