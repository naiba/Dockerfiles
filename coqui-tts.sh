#!/bin/sh
DOCKER_BUILDER_COMMIT_HASH=29a5be3
TTS_VERSION=0.3.1
TARGETARCH=amd64
TARGETVARIANT=
git clone https://github.com/synesthesiam/coqui-docker.git && \
    cd coqui-docker && \
    git checkout $DOCKER_BUILDER_COMMIT_HASH && \
    cd coqui-tts && \
    DOCKER_BUILDKIT=1 docker build -t ghcr.io/$OWNER/coqui-tts --build-arg TTS_VERSION=$TTS_VERSION --build-arg TARGETARCH=$TARGETARCH --build-arg TARGETVARIANT=$TARGETVARIANT  . && \
    docker push ghcr.io/$OWNER/coqui-tts

