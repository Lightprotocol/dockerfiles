ARG BASE_IMAGE=ghcr.io/lightprotocol/solana:latest

FROM ${BASE_IMAGE}

ARG NODE_VERSION=16.16.0

RUN cd /tmp \
    && wget https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz \
    && tar -xJf node-v${NODE_VERSION}-linux-x64.tar.xz -C /usr/local --strip-components=1
RUN npm install \
    --location=global \
    typescript \
    yarn

ENTRYPOINT []
