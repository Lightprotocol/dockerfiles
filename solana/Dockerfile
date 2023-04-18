FROM rust:1-bullseye

ARG ANCHOR_TAG=v0.26.0
ARG SOLANA_BRANCH=v1.15
ARG SOLANA_PROGRAM_LIBRARY_TAG=account-compression-v0.1.8

# Workaround for OOM issue in libgit2:
# https://github.com/docker/build-push-action/issues/621
ENV CARGO_NET_GIT_FETCH_WITH_CLI=true

RUN apt update \
    && apt install -y \
    libssl-dev \
    libudev-dev \
    pkg-config \
    zlib1g-dev \
    llvm \
    clang \
    cmake \
    make \
    libprotobuf-dev \
    protobuf-compiler
RUN cargo install \
    --git https://github.com/coral-xyz/anchor \
    --tag ${ANCHOR_TAG} \
    anchor-cli \
    --locked
WORKDIR /usr/local/src
RUN git clone \
    -b ${SOLANA_BRANCH} \
    https://github.com/Lightprotocol/solana
RUN git clone \
    -b ${SOLANA_PROGRAM_LIBRARY_TAG} \
    https://github.com/solana-labs/solana-program-library
WORKDIR /usr/local/src/solana
RUN ./scripts/cargo-install-all.sh /usr/local
WORKDIR /usr/local/src/solana-program-library/account-compression
RUN anchor build
RUN mkdir -p /usr/local/lib/solana-program-library
RUN ln -s /usr/local/src/solana-program-library/account-compression/target/deploy/*.so \
    /usr/local/lib/solana-program-library

COPY entrypoint.sh /usr/local/bin

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
