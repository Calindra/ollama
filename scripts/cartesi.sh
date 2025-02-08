#!/bin/sh

set -e

./scripts/cartesi_setup.sh

echo "Compile ollama"
rm -rf ./ollama
docker build -t builder-riscv64 -f Dockerfile-build .
docker rm builder-riscv64-container || true
docker create --name builder-riscv64-container builder-riscv64
docker cp builder-riscv64-container:/opt/build/ollama ./ollama
docker rm builder-riscv64-container

rm -rf ./dapp_v1

cartesi create dapp_v1 --template typescript

echo "Pristine dapp created with success!"

cp ./ollama ./dapp_v1/
rm ./dapp_v1/Dockerfile
cp ./scripts/cartesi-Dockerfile ./dapp_v1/Dockerfile

cd ./dapp_v1
cartesi build
cartesi run
