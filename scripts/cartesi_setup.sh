#!/bin/sh

set -eux

if ! npm list -g @cartesi/cli > /dev/null 2>&1; then
    echo "Installing Cartesi CLI..."
    npm install -g @cartesi/cli
else
    echo "Cartesi CLI is already installed."
fi

docker run --privileged --rm tonistiigi/binfmt:riscv || true

cartesi doctor

echo "Cartesi setup success!"