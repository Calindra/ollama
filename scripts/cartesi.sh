#!/bin/sh

set -eux

export BUILDX_PROGRESS=plain
export BUILDKIT_PROGRESS=plain

if [ -z "$(command -v docker)" ]; then
    echo "Docker is not installed. Please install Docker and try again."
    exit 1
fi

if [ -z "$(command -v cartesi)" ]; then
    echo "Cartesi CLI is not installed. Please install Cartesi CLI and try again."
    exit 1
fi

docker stop $(docker ps -q) || true

docker buildx rm --force --all-inactive
docker buildx prune --all --force && docker system prune --volumes --force

./scripts/cartesi_setup.sh

echo "Compile ollama"
rm -rfv ./ollama
docker build -t builder-riscv64 -f Dockerfile-build .
docker rm builder-riscv64-container || true
docker create --name builder-riscv64-container builder-riscv64
docker cp builder-riscv64-container:/opt/build/ollama ./ollama
docker rm builder-riscv64-container

rm -rfv ./dapp_v1

cartesi create dapp_v1 --template typescript

echo "Pristine dapp created with success!"

cp -v ./ollama ./dapp_v1/
rm -v ./dapp_v1/Dockerfile
cp -v ./scripts/cartesi-Dockerfile ./dapp_v1/Dockerfile
cp -v ./scripts/cartesi-index.ts  ./dapp_v1/src/index.ts

cd ./dapp_v1
cartesi build

echo "Cartesi Machine builded with success!"
cartesi run
