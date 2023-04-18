#!/bin/bash

set -e

solana config set --url http://localhost:8899

exec /usr/local/bin/solana-test-validator \
    "$@"
