ARG BASE_IMAGE=node:16-bullseye

FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --assume-yes --no-install-recommends \
    neovim \
    jq \
    zstd
RUN update-alternatives --set editor /usr/bin/nvim

RUN corepack enable
RUN corepack prepare pnpm@8.9.2 --activate
RUN env SHELL=/bin/bash pnpm setup

USER node
WORKDIR /home/node

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/home/node/.cargo/bin:${PATH}"
RUN rustup component add rustfmt

RUN mkdir -p /home/node/.npm-global
RUN npm config set prefix /home/node/.npm-global
RUN echo "PATH=\"/home/node/.npm-global/bin:/home/node/.cargo/bin:\$PATH\"" >> /home/node/.bashrc

RUN sh -c "$(curl -sSfL https://release.solana.com/v1.16.18/install)"
RUN cargo install cargo-expand

RUN npm install -g \
    typescript \
    typescript-language-server@3.3.2

# To ensure that the `/home/node/.config/solana` volume is going to be owned by
# the `node` user. Otherwise it'd be owned by root.
RUN mkdir -p /home/node/.config/solana

ENTRYPOINT []
