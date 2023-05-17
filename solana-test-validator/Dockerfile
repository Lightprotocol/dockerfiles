ARG BASE_IMAGE=ghcr.io/lightprotocol/devcontainer:main

FROM ${BASE_IMAGE}

COPY entrypoint.sh /home/node/.local/light-protocol/bin/entrypoint.sh

ENTRYPOINT ["/home/node/.local/light-protocol/bin/entrypoint.sh"]
