ARG BASE_IMAGE=ghcr.io/lightprotocol/devcontainer-core:main

FROM ${BASE_IMAGE}

USER node

RUN pnpm install -g only-allow @lightprotocol/cli

WORKDIR /home/node

ENTRYPOINT []
