#!/bin/bash

set -eux

if [[ "${POD_NAME}" == "solana-0" ]]; then
    /bootstrap-validator.sh
else
    /validator.sh
fi
