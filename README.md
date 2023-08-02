# Docker + Wasm + Wasm Workers Server (wws)

This repo showcases some functions you can write, taking advantage of
Wasm Workers Server, on top of Docker Desktop, thanks to the
[`containerd-wasm-shims`](https://github.com/deislabs/containerd-wasm-shims) project.

## Build

Prerequisites for building this project:

- Docker, with [Docker + Wasm support](https://docs.docker.com/desktop/wasm/)
- [Nix](https://github.com/NixOS/nix)

In order to build this example, you just have to run on the root of
this project:

```shell-session
$ make build
```

## Running

Prerequisites for running this project: Docker Desktop with
`containerd-wasm-shims`
[v0.8.0](https://github.com/deislabs/containerd-wasm-shims/releases/tag/v0.8.0)
at least.

You can run the example:

```shell-session
$ make run
```

After that, you can target the different endpoints exposed by the Wasm
Workers Server:

```shell-session
$ curl http://localhost:3000/user-generation-rust
$ curl http://localhost:3000/user-generation-go
$ curl http://localhost:3000/user-generation-js
$ curl http://localhost:3000/user-generation-python
$ curl http://localhost:3000/user-generation-ruby
```

This example also showcases how it is possible to make available to
the WebAssembly guest a file mounted from the Docker host. This
example can be executed with:

```shell-session
$ make run-with-mount
```

You can reach the same endpoints, but you will notice that the
attribute `.some_file_contents` of the produced JSON in all examples
now is the content of
https://github.com/ereslibre/docker-wws-demo/blob/main/tmp/file.txt
from the host.

The only worker that is not able to read contents from the filesystem
is the JS one, so you can only check it with the rest:

```shell-session
$ curl http://localhost:3000/user-generation-rust
$ curl http://localhost:3000/user-generation-go
$ curl http://localhost:3000/user-generation-python
$ curl http://localhost:3000/user-generation-ruby
```
