ARG BASE_IMAGE=debian:bullseye-slim

FROM ${BASE_IMAGE}

# RPC JSON
EXPOSE 8899/tcp
# RPC pubsub
EXPOSE 8900/tcp
# entrypoint
EXPOSE 8001/tcp
# (future) bank service
EXPOSE 8901/tcp
# bank service
EXPOSE 8902/tcp
# faucet
EXPOSE 9900/tcp
# tvu
EXPOSE 8000/udp
# gossip
EXPOSE 8001/udp
# tvu_forwards
EXPOSE 8002/udp
# tpu
EXPOSE 8003/udp
# tpu_forwards
EXPOSE 8004/udp
# retransmit
EXPOSE 8005/udp
# repair
EXPOSE 8006/udp
# serve_repair
EXPOSE 8007/udp
# broadcast
EXPOSE 8008/udp
# tpu_vote
EXPOSE 8009/udp

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --assume-yes --no-install-recommends \
    bzip2 \
    ca-certificates \
    curl \
    libssl-dev \
    zstd

ARG SOLANA_VERSION=1.15.2

RUN curl -L \
    -o /usr/local/bin/solana-run.sh \
    https://raw.githubusercontent.com/Lightprotocol/solana/v${SOLANA_VERSION}/scripts/run.sh
RUN curl -L \
    -o /usr/local/bin/fetch-spl.sh \
    https://raw.githubusercontent.com/Lightprotocol/solana/v${SOLANA_VERSION}/scripts/fetch-spl.sh

RUN groupadd --gid 1000 solana \
    && useradd --uid 1000 --gid solana --shell /bin/bash --create-home solana

USER solana

RUN curl -s \
    https://raw.githubusercontent.com/Lightprotocol/install/main/light-protocol-install.sh | \
    bash -s -- \
    --no-prompt \
    --skip-light-protocol-toolchain \
    --skip-light-protocol-programs
RUN echo "PATH=$PATH:/home/solana/.local/light-protocol/bin" >> \
    /home/solana/.profile
RUN echo "PATH=$PATH:/home/solana/.local/light-protocol/bin" >> \
    /home/solana/.bashrc

RUN mkdir -p /home/solana/accounts
WORKDIR /home/solana/accounts
RUN curl -s https://api.github.com/repos/Lightprotocol/accounts/contents/ | \
    jq -r '.[] | select(.name|test(".json$")) | .download_url' | \
    while read url; do curl -O "$url"; done

WORKDIR /

COPY common.sh .
COPY genesis.sh .
COPY bootstrap-validator.sh .
COPY validator.sh .

ENV PATH="/home/solana/.local/light-protocol/bin:${PATH}"

ENTRYPOINT ["/validator.sh"]
