#!/bin/sh

set -e
set -x

cd "$(dirname "$0")"

# Default value for MPS_VERSION
MPS_VERSION="${MPS_VERSION:=2023.2.2}"

MPS_MAJOR_VERSION=`echo $MPS_VERSION | grep -oE '20[0-9]{2}\.[0-9]+'`
IMAGE_VERSION="$(./version.sh)"

cd src

docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --push \
  --build-arg MPS_VERSION=$MPS_VERSION \
  -t "modelix/mps-vnc-baseimage:${IMAGE_VERSION}-mps${MPS_VERSION}" \
  -t "modelix/mps-vnc-baseimage:${IMAGE_VERSION}-mps${MPS_MAJOR_VERSION}" \
  .
