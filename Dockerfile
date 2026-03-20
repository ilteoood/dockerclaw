FROM ubuntu:24.04

LABEL maintainer.name="Matteo Pietro Dazzi" \
    maintainer.email="matteopietro.dazzi@gmail.com" \
    description="ZeroClaw - Personal AI Assistant in Docker"

ARG TARGETARCH

COPY src/* /usr/local/bin/

RUN apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends \
    curl ca-certificates tar && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    download_zeroclaw $TARGETARCH

WORKDIR /home/workspace

EXPOSE 42617

ENTRYPOINT [ "entrypoint" ]
