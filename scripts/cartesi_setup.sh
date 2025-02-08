#!/bin/sh

set -e

npm i -g @cartesi/cli

docker run --privileged --rm tonistiigi/binfmt:riscv || true

cartesi doctor

echo "Cartesi setup success!"