#!/bin/bash

set -eux

source common.sh

FAUCET_KEYPAIR="${SOLANA_CONFIG_DIR}/faucet.json"
STAKE_KEYPAIR="${LEDGER_DIR}/stake-account.json"

if [[ -d $LEDGER_DIR ]]; then
  echo "Bootstrap accounts and genesis hash already initialized"
  exit 0
fi

mkdir -p "${LEDGER_DIR}"

if [[ ! -f $FAUCET_KEYPAIR ]]; then
  solana-keygen new --no-passphrase -fso "$FAUCET_KEYPAIR"
fi
if [[ ! -f $IDENTITY_KEYPAIR ]]; then
  solana-keygen new --no-passphrase -so "$IDENTITY_KEYPAIR"
fi
if [[ ! -f $STAKE_KEYPAIR ]]; then
  solana-keygen new --no-passphrase -so "$STAKE_KEYPAIR"
fi
if [[ ! -f $VOTE_KEYPAIR ]]; then
  solana-keygen new --no-passphrase -so "$VOTE_KEYPAIR"
fi

solana-genesis \
  --max-genesis-archive-unpacked-size 1073741824 \
  --enable-warmup-epochs \
  --bootstrap-validator \
    "$IDENTITY_KEYPAIR" \
    "$VOTE_KEYPAIR" \
    "$STAKE_KEYPAIR" \
  --ledger "$LEDGER_DIR" \
  --faucet-pubkey "$FAUCET_KEYPAIR" \
  --faucet-lamports 500000000000000000 \
  --hashes-per-tick auto \
  --cluster-type development
