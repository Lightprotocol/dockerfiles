ARG BASE_IMAGE=node:16-bullseye

FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --assume-yes --no-install-recommends \
    neovim \
    jq \
    zstd
RUN update-alternatives --set editor /usr/bin/nvim

USER node

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/home/node/.cargo/bin:${PATH}"
RUN rustup toolchain install nightly

RUN curl -s \
    https://raw.githubusercontent.com/Lightprotocol/install/main/light-protocol-install.sh | \
    bash -s -- --no-prompt
RUN echo "PATH=$PATH:/home/node/.cargo/bin:/home/node/.local/light-protocol/bin" >> \
    /home/node/.profile
RUN echo "PATH=$PATH:/home/node/.cargo/bin:/home/node/.local/light-protocol/bin" >> \
    /home/node/.bashrc

ARG NOOP_PROGRAM_VERSION=0.1.3

RUN mkdir -p /home/node/.local/light-protocol/lib/solana-program-library
RUN curl -L \
    -o /home/node/.local/light-protocol/lib/solana-program-library/spl_noop.so \
    https://github.com/Lightprotocol/solana-program-library/releases/download/noop-${NOOP_PROGRAM_VERSION}/spl_noop.so

# To ensure that the `/home/node/.config/solana` volume is going to be owned by
# the `node` user. Otherwise it'd be owned by root.
RUN mkdir -p /home/node/.config/solana

ENTRYPOINT []
