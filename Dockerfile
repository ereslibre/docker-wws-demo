# syntax=docker/dockerfile:labs

FROM --platform=$BUILDPLATFORM rust:1.72.0-alpine AS base
RUN apk add sudo curl musl-dev ca-certificates && \
    curl -fsSL https://workers.wasmlabs.dev/install | sh

FROM base AS build-rust
WORKDIR /src
RUN --mount=type=bind,target=/src,source=./apps-src/user-generation-rust \
    cargo build --release --target-dir /output

FROM scratch AS release-rust
COPY --from=build-rust /output/wasm32-wasi/release/user-generation-rust.wasm /
COPY ./apps-src/user-generation-rust/user-generation-rust.toml /

FROM scratch AS release-js
COPY ./apps-src/user-generation-js/ /

FROM scratch AS release-ruby
COPY ./apps-src/user-generation-ruby /user-generation-ruby

FROM scratch AS release-python
COPY ./apps-src/user-generation-python/ /user-generation-python

FROM --platform=$BUILDPLATFORM tinygo/tinygo:0.28.1 AS build-go
WORKDIR /src
RUN --mount=type=bind,target=/src,source=./apps-src/user-generation-go \
    tinygo build \
        -o /home/tinygo/user-generation-go.wasm \
        -no-debug -panic=trap -scheduler=none -gc=leaking \
        -target=wasi .

FROM scratch AS release-go
COPY --from=build-go /home/tinygo/user-generation-go.wasm /
COPY ./apps-src/user-generation-go/user-generation-go.toml /

FROM base AS build-root
WORKDIR /output
RUN wws runtimes install ruby latest
RUN wws runtimes install python latest
COPY ./apps-src/tmp /output/tmp

FROM scratch AS release-root
COPY --from=build-root /output /

FROM scratch AS release
COPY --from=release-root / /
COPY --from=release-rust / /
COPY --from=release-js / /
COPY --from=release-ruby / /
COPY --from=release-python / /
COPY --from=release-go / /
COPY --from=base /etc/ssl /etc/ssl

ENTRYPOINT ["/"]
