#!/bin/bash

template="$1"

docker run --rm \
  --name init \
  -e PACKER_LOG=1 \
  -e PACKER_PLUGIN_PATH="." \
  -e PACKER_LOG_PATH="packer-docker.log" \
  -it \
  --privileged \
  -v `pwd`:/opt/ \
  -w /opt/ test init .


docker run --rm \
  --name builder \
  -e PACKER_LOG=1 \
  -e PACKER_PLUGIN_PATH="." \
  -e PACKER_LOG_PATH="packer-docker.log" \
  -it \
  --privileged \
  -v `pwd`:/opt/ \
  -w /opt/ \
  test build .
