ARG BASE_IMAGE=ghcr.io/lightprotocol/devcontainer-core:main

FROM ${BASE_IMAGE}

USER node

RUN yarn global add @lightprotocol/cli

RUN curl -s \
    https://raw.githubusercontent.com/Lightprotocol/install/main/light-protocol-install.sh | \
    bash -s -- --no-prompt --skip-toolchain

RUN mkdir -p /home/node/.local/light-protocol/lib/accounts
WORKDIR /home/node/.local/light-protocol/lib/accounts
RUN curl -s https://api.github.com/repos/Lightprotocol/accounts/contents/ | \
    jq -r '.[] | select(.name|test(".json$")) | .download_url' | \
    while read url; do curl -O "$url"; done

WORKDIR /home/node

ENTRYPOINT []
