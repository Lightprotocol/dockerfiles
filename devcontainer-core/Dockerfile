ARG BASE_IMAGE=node:16-bullseye

FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --assume-yes --no-install-recommends \
    neovim \
    jq \
    zstd
RUN update-alternatives --set editor /usr/bin/nvim

RUN corepack enable

USER node
WORKDIR /home/node

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/home/node/.cargo/bin:${PATH}"
RUN rustup component add rustfmt

RUN npm config set npm-prefix /home/node/.npm-global
RUN echo "PATH=\"/home/node/.npm-global/bin:/home/node/.cargo/bin:\$PATH\"" >> /home/node/.bashrc


RUN mkdir -p /home/node/.pnpm/bin
RUN echo "PNPM_HOME=/home/node/.pnpm/bin"  >> /home/node/.bashrc
RUN pnpm config set pnpm-prefix /home/node/.pnpm-global
RUN echo "PATH=\"/home/node/.pnpm-global/bin:/home/node/.cargo/bin:\$PATH\"" >> /home/node/.bashrc


RUN pnpm install -g \
    typescript \
    typescript-language-server

# To ensure that the `/home/node/.config/solana` volume is going to be owned by
# the `node` user. Otherwise it'd be owned by root.
RUN mkdir -p /home/node/.config/solana

ENTRYPOINT []
