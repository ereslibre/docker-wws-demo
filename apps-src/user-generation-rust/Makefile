.PHONY: target/wasm32-wasi/release/user-generation-rust.wasm
target/wasm32-wasi/release/user-generation-rust.wasm:
	nix shell github:ereslibre/nixities#cargo github:ereslibre/nixities#clang --command cargo build --release --target wasm32-wasi
