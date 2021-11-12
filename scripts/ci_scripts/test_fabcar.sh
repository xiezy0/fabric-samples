#!/bin/bash

SCRIP_PATH=$(readlink -f "$(dirname "$0")")
# fix unable write to zhonghuan private key db file
CURRENT_USER_ID=0
DOCKER_GROUP_ID=$(getent group docker | cut -d ':' -f 3)

docker build --build-arg IMAGE_CA=${IMAGE_CA-twblockchain/fabric-ca:latest} \
             --build-arg IMAGE_TOOLS=${IMAGE_TOOLS-twblockchain/fabric-tools:latest} \
             -t twblockchain/fabric-tools-ca:latest \
             - < $SCRIP_PATH/Dockerfile

docker run --rm \
    -u "$CURRENT_USER_ID:$DOCKER_GROUP_ID" \
    -v "$PWD:$PWD" \
    -v "$(command -v docker):$(command -v docker)" \
    -v "$(command -v docker-compose):$(command -v docker-compose)" \
    -v "/var/run/docker.sock:/var/run/docker.sock" \
    -w "$PWD/fabcar" \
    -e "IMAGE_PEER" \
    -e "IMAGE_ORDERER" \
    -e "IMAGE_CA" \
    -e "IMAGE_TOOLS" \
    -e "IMAGE_CCENV" \
    -e "BYFN_CA" \
    -e "ALIBABA_CLOUD_REGION" \
    -e "ALIBABA_CLOUD_ACCESS_KEY_ID" \
    -e "ALIBABA_CLOUD_ACCESS_KEY_SECRET" \
    --network host \
    twblockchain/fabric-tools-ca:latest \
    $1
