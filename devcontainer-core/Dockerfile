ARG BASE_IMAGE=node:16-bullseye

FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --assume-yes --no-install-recommends \
    neovim \
    jq \
    zstd
RUN update-alternatives --set editor /usr/bin/nvim

USER node
WORKDIR /home/node

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/home/node/.cargo/bin:${PATH}"

RUN echo "PATH=\"/home/node/.cargo/bin:\$PATH\"" >> /home/node/.bashrc

RUN yarn global add \
    typescript \
    typescript-language-server@3.3.2

# To ensure that the `/home/node/.config/solana` volume is going to be owned by
# the `node` user. Otherwise it'd be owned by root.
RUN mkdir -p /home/node/.config/solana

ENTRYPOINT []
