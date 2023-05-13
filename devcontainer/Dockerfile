ARG BASE_IMAGE=ghcr.io/lightprotocol/devcontainer-core:latest

FROM ${BASE_IMAGE}

USER node

RUN curl -s \
    https://raw.githubusercontent.com/Lightprotocol/install/main/light-protocol-install.sh | \
    bash -s -- --no-prompt --skip-toolchain
