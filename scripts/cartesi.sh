#!/bin/sh

set -eux

export BUILDX_PROGRESS=plain
export BUILDKIT_PROGRESS=plain

if [ -z "$(command -v docker)" ]; then
    echo "Docker is not installed. Please install Docker and try again."
    exit 1
fi

# Check if there are any running containers before trying to stop them
if [ ! -z "$(docker ps -q)" ]; then
    echo "Stopping running containers..."
    docker stop $(docker ps -q)
fi

docker buildx rm --force --all-inactive
docker buildx prune --all --force && docker system prune --volumes --force

./scripts/cartesi_setup.sh

echo "Compile ollama"
rm -rfv ./ollama
docker build -t builder-riscv64 -f Dockerfile-build-optimize .
docker rm builder-riscv64-container || true
docker create --name builder-riscv64-container builder-riscv64
docker cp builder-riscv64-container:/opt/build/ollama ./ollama
docker rm builder-riscv64-container

# echo "Delete dapp_v1"
# rm -rf ./dapp_v1

# cartesi create dapp_v1 --template typescript

echo "Pristine dapp created with success!"

cp -v ./ollama ./dapp_v1/
rm -v ./dapp_v1/Dockerfile
cp -v ./scripts/cartesi-Dockerfile ./dapp_v1/Dockerfile
# cp -v ./scripts/cartesi-index.ts  ./dapp_v1/src/index.ts

cd ./dapp_v1
yarn install --frozen-lockfile && yarn run build
cartesi build

echo "Cartesi Machine built with success!"
cartesi run
