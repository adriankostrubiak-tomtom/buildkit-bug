#!/bin/sh

echo "building..."

# REPO="XXXXXXXXXXXXXX.azurecr.io/buildkit-bug"
REPO=""
if [ -z "$REPO" ]; then
    echo "No REPO defined."
    exit 1
fi

PWD=$(pwd)
mkdir -p "${PWD}/out"
docker run \
    -it \
    --rm \
    --privileged \
    -v "${PWD}:/tmp/work" \
    -v "${PWD}/out:/tmp/out" \
    -v ~/.docker:/root/.docker \
    --entrypoint buildctl-daemonless.sh \
    moby/buildkit:v0.8.2 \
        --addr tcp://host.docker.internal:1234 \
        build \
        --frontend  dockerfile.v0 \
        --opt source=docker/dockerfile:1.2.1 \
        --opt "filename=Dockerfile" \
        --opt "target=production" \
        --local context=/tmp/work \
        --local dockerfile=/tmp/work/build \
        --import-cache "type=registry,ref=${REPO}:buildcache" \
        --export-cache "type=registry,ref=${REPO}:buildcache" \
        --output "type=docker,name=sample-production,dest=/tmp/out/sample-production.tar"
