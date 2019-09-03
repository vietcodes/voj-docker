FROM rust:1.37.0-slim AS base

RUN apt-get update && \
    apt-get install -y --no-install-recommends libssl-dev libpq-dev libpq5 pkg-config && \
    rm -rf /var/lib/apt/lists/*

FROM base AS builder

RUN cargo install diesel_cli --no-default-features --features postgres && \
    cargo install sccache --no-default-features

FROM base

COPY --from=builder /usr/local/cargo/bin/sccache /usr/local/cargo/bin/sccache
COPY --from=builder /usr/local/cargo/bin/diesel /usr/local/cargo/bin/diesel

RUN rustup install nightly-2019-08-26 && \
    rustup default nightly-2019-08-26 && \
    rustup uninstall 1.37.0-x86_64-unknown-linux-gnu && \
    sccache --help && diesel --help

ENV RUSTC_WRAPPER /usr/local/cargo/bin/sccache

RUN mkdir /root/app
WORKDIR /root/app

VOLUME /root/.cache/sccache
VOLUME /usr/local/cargo/registry
VOLUME /usr/local/cargo/git
