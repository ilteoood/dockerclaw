# syntax=docker/dockerfile:1.7

# ── Stage 0: Download source ────────────────────────────────────
FROM debian:bookworm-slim AS source

RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates && \
    ZEROCLAW_VERSION=$(curl -fsSL "https://api.github.com/repos/zeroclaw-labs/zeroclaw/releases/latest" | \
      sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p') && \
    echo "Resolved latest release: ${ZEROCLAW_VERSION}" && \
    mkdir -p /source && \
    curl -fsSL "https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/${ZEROCLAW_VERSION}.tar.gz" | \
    tar -xzf - --strip-components=1 -C /source && \
    rm -rf /var/lib/apt/lists/*

# ── Stage 1: Frontend build ─────────────────────────────────────
FROM node:22-bookworm-slim AS web-builder

COPY --from=source /source/web /web
WORKDIR /web
RUN npm ci --ignore-scripts 2>/dev/null || npm install --ignore-scripts
RUN npm run build

# ── Stage 2: Build ───────────────────────────────────────────────
FROM rust:1.94-bookworm AS builder

WORKDIR /app

# Install build dependencies for all features
RUN apt-get update && apt-get install -y --no-install-recommends \
    pkg-config \
    libudev-dev \
    cmake \
    && rm -rf /var/lib/apt/lists/*

# Copy source and built frontend
COPY --from=source /source .
COPY --from=web-builder /web/dist web/dist

# Build with some features enabled
RUN cargo build --release --locked --features skill-creation,whatsapp-web,browser-native,rag-pdf,plugins-wasm && \
    cp target/release/zeroclaw /app/zeroclaw-bin && \
    strip /app/zeroclaw-bin

# Verify binary size (guard against dummy build artifacts)
RUN size=$(stat -c%s /app/zeroclaw-bin) && \
    if [ "$size" -lt 1000000 ]; then echo "ERROR: binary too small (${size} bytes), likely dummy build artifact" && exit 1; fi

# ── Stage 3: Runtime ─────────────────────────────────────────────
FROM ubuntu:24.04

LABEL maintainer.name="Matteo Pietro Dazzi" \
    maintainer.email="matteopietro.dazzi@gmail.com" \
    description="ZeroClaw - Personal AI Assistant in Docker"

RUN apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends \
    ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/zeroclaw-bin /usr/local/bin/zeroclaw
COPY src/* /usr/local/bin/

WORKDIR /home/workspace

EXPOSE 42617

ENTRYPOINT [ "entrypoint" ]
