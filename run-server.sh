#!/bin/sh

echo "Running Server..."
docker run --privileged -p 1234:1234 moby/buildkit:v0.8.2 --addr tcp://0.0.0.0:1234 --debug
