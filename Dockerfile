FROM alpine:3.12 AS base

WORKDIR /relay

FROM base AS builder

RUN apk -U upgrade && \
    apk add \
    build-base \
    openssl-dev \
    crystal \
    shards

COPY . ./

RUN shards update
RUN shards install --production
RUN shards build --release

FROM base AS runner

ENV RELAY_DOMAIN=relay.nya.one
ENV RELAY_HOST=0.0.0.0
ENV RELAY_PORT=8085
ENV RELAY_PKEY_PATH=/relay/key/actor.pem
ENV REDIS_URL=redis://redis/relay

ENTRYPOINT ["/relay/bin/pub-relay"]
VOLUME ["/relay/data"]

COPY --from=builder /relay/bin ./bin

CMD ["/relay/bin/pub-relay"]