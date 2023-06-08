#!/bin/bash  

set -eux

source common.sh

# sudo sh -c "ulimit -n 1000000"
export LimitNOFILE=1000000

solana-validator \
    --ledger "${LEDGER_DIR}" \
    --rpc-port 8899 \
    --snapshot-interval-slots 200 \
    --no-incremental-snapshots \
    --identity "${IDENTITY_KEYPAIR}" \
    --vote-account "${VOTE_KEYPAIR}" \
    --rpc-faucet-address 127.0.0.1:9900 \
    --no-poh-speed-test \
    --no-os-network-limits-test \
    --no-wait-for-vote-to-start-leader \
    --full-rpc-api \
    --gossip-port 8001 \
    --log -