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
