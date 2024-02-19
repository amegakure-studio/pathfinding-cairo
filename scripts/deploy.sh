#!/bin/bash

source .env
set -e

GREEN='\e[32m'
RESET='\e[0m'

# Declare all contracts
echo -e "$GREEN\n==> Declare Pathfinder$RESET"
DECLARED_CLASSHASH=$(starkli declare --watch \
    --account $ACCOUNT_SRC \
    --rpc $RPC_URL \
    --keystore $KEYSTORE_SRC \
    --keystore-password $KEYSTORE_PASSWORD \
    ./target/dev/pathfinding_Pathfinder.contract_class.json)

echo -e "$GREEN\nDeclared Classhash: $DECLARED_CLASSHASH$RESET"

# echo -e "$GREEN\n==> Deploy Pathfinder$RESET"
# CONTRACT_ADDRESS=$(starkli deploy --watch \
#     --account $ACCOUNT_SRC \
#     --rpc $RPC_URL \
#     --keystore $KEYSTORE_SRC \
#     --keystore-password $KEYSTORE_PASSWORD \
#     $DECLARED_CLASSHASH)

# echo -e "$GREEN$\nDeployed contract address: $CONTRACT_ADDRESS$RESET"
