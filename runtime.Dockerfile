FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y --no-install-recommends libpq5 && \
    rm -rf /var/lib/apt/lists/*

COPY --from=voj-builder /usr/local/cargo/bin/diesel /usr/bin/diesel
