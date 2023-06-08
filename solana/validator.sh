#!/bin/bash

set -eux

source common.sh

AUTHORIZED_WITHDRAWER_KEYPAIR="${LEDGER_DIR}/authorized-withdrawer.json"

airdrops_enabled=1
node_sol=500 # 500 SOL: number of SOL to airdrop the node for transaction fees and vote account rent exemption (ignored if airdrops_enabled=0)
gossip_entrypoint=127.0.0.1:8001

if [[ ! -f $AUTHORIZED_WITHDRAWER_KEYPAIR ]]; then
  solana-keygen new --no-passphrase -so "$AUTHORIZED_WITHDRAWER_KEYPAIR"
fi

rpc_url=$(solana-gossip rpc-url --timeout 180 --entrypoint "$gossip_entrypoint")

setup_validator_accounts() {
  declare node_sol=$1

  if ! solana vote-account "${VOTE_KEYPAIR}"; then
    if ((airdrops_enabled)); then
      echo "Adding $node_sol to validator identity account:"
      (
        set -x
        $solana_cli \
          --keypair "$SOLANA_CONFIG_DIR/faucet.json" \
          --url "$rpc_url" \
          transfer --allow-unfunded-recipient "${IDENTITY_KEYPAIR}" "$node_sol"
      ) || return $?
    fi

    echo "Creating validator vote account"
    solana create-vote-account \
        "${VOTE_KEYPAIR}" \
        "${IDENTITY_KEYPAIR}" \
        "${AUTHORIZED_WITHDRAWER_KEYPAIR}"
  fi
  echo "Validator vote account configured"

  echo "Validator identity account balance:"
  solana balance || return $?

  return 0
}

setup_validator_accounts "$node_sol"

solana-validator \
    --max-genesis-archive-unpacked-size 1073741824 \
    --no-poh-speed-test \
    --no-os-network-limits-test \
    --identity "${IDENTITY_KEYPAIR}" \
    --vote-account "${VOTE_KEYPAIR}" \
    --ledger "${LEDGER_DIR}" \
    --log - \
    --full-rpc-api \
    --no-incremental-snapshots \
    --require-tower
