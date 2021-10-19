## Why crystal 0.36.1? 
### circuit_breaker requires < 1.0.0 while openssl_ext requires >= 0.36.1 , 
### so this is the only valid version (sigh)


FROM crystallang/crystal:0.36.1-alpine-build AS builder

WORKDIR /relay

COPY . ./

RUN shards update
RUN shards build --release

FROM crystallang/crystal:0.36.1-alpine AS runner

WORKDIR /relay

VOLUME ["/relay/data"]

COPY --from=builder /relay/bin /relay/bin

CMD ["/relay/bin/pub-relay"]