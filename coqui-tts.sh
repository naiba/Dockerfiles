#!/bin/sh
DOCKER_BUILDER_COMMIT_HASH=29a5be3
TTS_VERSION=0.3.1
TARGETARCH=amd64
TARGETVARIANT=
git clone https://github.com/synesthesiam/coqui-docker.git && \
    cd coqui-docker && \
    git checkout $DOCKER_BUILDER_COMMIT_HASH && \
    cd coqui-tts && \
    sed -i 's/docker.io/ghcr.io/' Makefile && \
    sed -i 's/synesthesiam/naiba/' Makefile && \
    make cpu
