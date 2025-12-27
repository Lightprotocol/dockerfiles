# Versions - keep in sync with light-protocol/scripts/devenv/versions.sh
ARG NODE_VERSION=22
ARG BASE_IMAGE=node:${NODE_VERSION}-bookworm

FROM ${BASE_IMAGE}

# Tool versions from light-protocol/scripts/devenv/versions.sh
ARG RUST_VERSION=1.90.0
ARG PNPM_VERSION=9.2.0
ARG SOLANA_VERSION=2.2.15
ARG GO_VERSION=1.25.5
ARG ANCHOR_VERSION=0.31.1
ARG JQ_VERSION=1.8.0
ARG PHOTON_VERSION=0.51.2
ARG PHOTON_COMMIT=3dbfb8e6772779fc89c640b5b0823b95d1958efc

ENV DEBIAN_FRONTEND=noninteractive

# System dependencies
RUN apt-get update && apt-get install --assume-yes --no-install-recommends \
    neovim \
    zstd \
    build-essential \
    pkg-config \
    libssl-dev \
    libudev-dev \
    clang \
    lld \
    cmake \
    ca-certificates \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --set editor /usr/bin/nvim

# Install jq with pinned version
ARG TARGETARCH
RUN case "${TARGETARCH}" in \
        amd64) JQ_ARCH="amd64" ;; \
        arm64) JQ_ARCH="arm64" ;; \
        *) echo "Unsupported arch: ${TARGETARCH}" && exit 1 ;; \
    esac && \
    curl --retry 5 --retry-delay 10 -sSL -o /usr/local/bin/jq "https://github.com/jqlang/jq/releases/download/jq-${JQ_VERSION}/jq-linux-${JQ_ARCH}" && \
    chmod +x /usr/local/bin/jq

# Install Go
RUN case "${TARGETARCH}" in \
        amd64) GO_ARCH="amd64" ;; \
        arm64) GO_ARCH="arm64" ;; \
        *) echo "Unsupported arch: ${TARGETARCH}" && exit 1 ;; \
    esac && \
    curl --retry 5 --retry-delay 10 -sSL -o /tmp/go.tar.gz "https://go.dev/dl/go${GO_VERSION}.linux-${GO_ARCH}.tar.gz" && \
    tar -xzf /tmp/go.tar.gz -C /usr/local && \
    rm /tmp/go.tar.gz

ENV GOROOT=/usr/local/go
ENV PATH="${GOROOT}/bin:${PATH}"

# Setup pnpm
RUN corepack enable && \
    corepack prepare pnpm@${PNPM_VERSION} --activate && \
    env SHELL=/bin/bash pnpm setup

# Switch to node user for remaining installations
USER node
WORKDIR /home/node

# Setup directories
RUN mkdir -p /home/node/.npm-global /home/node/.config/solana

# Install Rust with specific version
ENV RUSTUP_HOME=/home/node/.rustup
ENV CARGO_HOME=/home/node/.cargo
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain ${RUST_VERSION} --no-modify-path && \
    . /home/node/.cargo/env && \
    rustup install nightly && \
    rustup component add rustfmt clippy

ENV PATH="/home/node/.cargo/bin:${PATH}"

# Install Solana CLI (Agave) via Anza installer
RUN curl --retry 5 --retry-delay 10 -sSfL https://release.anza.xyz/v${SOLANA_VERSION}/install -o /tmp/solana-install.sh && \
    sh /tmp/solana-install.sh && \
    rm /tmp/solana-install.sh && \
    /home/node/.local/share/solana/install/active_release/bin/solana --version
ENV PATH="/home/node/.local/share/solana/install/active_release/bin:${PATH}"

# Install Anchor CLI directly
RUN cargo install --git https://github.com/coral-xyz/anchor --tag v${ANCHOR_VERSION} anchor-cli --locked --force

# Install Photon indexer
RUN RUSTFLAGS="-A dead-code" cargo install \
    --git https://github.com/helius-labs/photon.git \
    --rev ${PHOTON_COMMIT} \
    --locked --force

# Install cargo-expand
RUN cargo install cargo-expand

# Setup npm global prefix
RUN npm config set prefix /home/node/.npm-global

# Install npm global packages
RUN npm install -g \
    typescript \
    typescript-language-server@4.4.0

# Update PATH in bashrc
RUN echo 'export PATH="/home/node/.npm-global/bin:/home/node/.cargo/bin:/home/node/.local/share/solana/install/active_release/bin:$PATH"' >> /home/node/.bashrc

# Also set PATH globally for all users (needed when running as root)
USER root
RUN echo 'export PATH="/home/node/.npm-global/bin:/home/node/.cargo/bin:/home/node/.local/share/solana/install/active_release/bin:$PATH"' >> /etc/profile.d/light-protocol.sh
USER node

# Clean up cargo registry cache to reduce image size
RUN rm -rf /home/node/.cargo/registry/cache

ENTRYPOINT []
