.PHONY: all
all: user-generation-go user-generation-js user-generation-python user-generation-ruby user-generation-rust root/.wws.toml

root/.wws.toml: ../apps-src/.wws.toml
	cp $< $@

.PHONY: user-generation-go
user-generation-go: ../apps-src/user-generation-go
	make -C $<
	cp $</user-generation-go.wasm root
	cp $</user-generation-go.toml root

.PHONY: user-generation-js
user-generation-js: ../apps-src/user-generation-js
	cp $</* root

.PHONY: user-generation-python
user-generation-python: ../apps-src/user-generation-python
	mkdir -p root/$@
	cp -r $</* root/$@

.PHONY: user-generation-ruby
user-generation-ruby: ../apps-src/user-generation-ruby
	mkdir -p root/$@
	cp -r $</* root/$@

.PHONY: user-generation-rust
user-generation-rust: ../apps-src/user-generation-rust
	make -C $<
	cp $</target/wasm32-wasi/release/user-generation-rust.wasm root
	cp $</user-generation-rust.toml root

.PHONY: run
run: all
	cd ../wasm-workers-server && nix develop github:ereslibre/nixities#work.wws --command cargo run -- --enable-panel --host 0.0.0.0 ${PWD}/root

.PHONY: image
image:
	docker buildx build --platform wasi/wasm --provenance=false -t ereslibre/wws-demo:latest .

.PHONY: clean
clean:
	rm -rf root
	git checkout root
