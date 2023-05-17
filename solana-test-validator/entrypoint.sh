#!/bin/bash

set -e

export PATH="/home/node/.local/light-protocol/bin:/home/node/.cargo/bin:${PATH}"

KEYPAIR_FILE="${HOME}/.config/solana/id.json"

solana config set --url http://localhost:8899

if [[ ! -f "${KEYPAIR_FILE}" ]]; then
    echo "No keypair found, generating a new one..."
    solana-keygen new --no-bip39-passphrase -o "${KEYPAIR_FILE}"
fi

exec /home/node/.local/light-protocol/bin/solana-test-validator "$@"
