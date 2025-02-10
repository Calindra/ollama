#!/bin/sh

set -e

export BUILDX_PROGRESS=plain
export BUILDKIT_PROGRESS=plain

docker stop $(docker ps -q) || true

docker buildx rm --force --all-inactive
docker buildx prune --all --force && docker system prune --volumes --force

if command -v ollama &> /dev/null; then
    echo "Ollama detected"
else
    echo "Install ollama"
    curl -fsSL https://ollama.com/install.sh | sh
fi

ollama serve &
ollama pull qwen2.5:0.5b
rm -rfv ./dapp_v1/.ollama
cp -v ~/.ollama ./dapp_v1/

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
cp ./scripts/cartesi-index.ts  ./dapp_v1/src/index.ts

cd ./dapp_v1
cartesi build

echo "Cartesi Machine builded with success!"
cartesi run
