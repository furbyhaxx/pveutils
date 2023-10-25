#!/bin/bash

UNISON_VERSION=2.53.3

echo "Install Unison." \
    && pushd /tmp \
    && wget https://github.com/bcpierce00/unison/archive/v$UNISON_VERSION.tar.gz \
    && tar -xzvf v$UNISON_VERSION.tar.gz \
    && rm v$UNISON_VERSION.tar.gz \
    && pushd unison-$UNISON_VERSION \
    && make \
    && cp -t /usr/local/bin ./src/unison ./src/unison-fsmonitor \
    && popd \
    && rm -rf unison-$UNISON_VERSION \
    && popd
