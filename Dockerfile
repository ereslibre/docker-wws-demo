FROM --platform=$BUILDPLATFORM rust:1.72.0 as build-rust
RUN --mount=type=bind,target=/src,source=./apps-src/user-generation-rust \
    cd /src && RUSTFLAGS=-Cstrip=symbols cargo build --release --target wasm32-wasi --target-dir /output

FROM scratch as release-rust
COPY --from=build-rust /output/wasm32-wasi/release/user-generation-rust.wasm /
COPY ./apps-src/user-generation-rust/user-generation-rust.toml /

FROM scratch as release-js
COPY ./apps-src/user-generation-js/ /

FROM scratch as release-ruby
COPY ./apps-src/user-generation-ruby /user-generation-ruby

FROM scratch as release-python
COPY ./apps-src/user-generation-python/ /user-generation-python

FROM --platform=$BUILDPLATFORM tinygo/tinygo:0.28.1 as build-go
RUN --mount=type=bind,target=/src,source=./apps-src/user-generation-go \
    cd /src && tinygo build -o /home/tinygo/user-generation-go.wasm -target=wasi .

FROM scratch as release-go
COPY --from=build-go /home/tinygo/user-generation-go.wasm /
COPY ./apps-src/user-generation-go/user-generation-go.toml /

FROM scratch
COPY ./apps-src/root/ /
COPY --from=release-rust / /
COPY --from=release-js / /
COPY --from=release-ruby / /
COPY --from=release-python / /
COPY --from=release-go / /
COPY --from=build-rust /etc/ssl /etc/ssl

ENTRYPOINT ["."]
