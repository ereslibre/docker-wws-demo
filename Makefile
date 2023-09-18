.PHONY: image
image:
	docker build --platform wasi/wasm --provenance=false --tag=wws-apps:latest .

.PHONY: dist
dist: clean
	docker build --platform wasi/wasm --provenance=false --output=dist .

.PHONY: run-local
run-local: dist
	cd wasm-workers-server && \
	nix develop github:ereslibre/nixities#work.wws --command \
		cargo run -- --enable-panel --host 0.0.0.0 $(PWD)/dist

.PHONY: run
run: stop image
	docker run --rm -d --name docker-wws \
	  -p 3000:3000 \
	  --runtime=io.containerd.wws.v1 \
	  --platform=wasi/wasm \
	  wws-apps:latest
	@echo "Now you can reach the Wasm Workers Server functions, such as:"
	@echo "  - curl http://localhost:3000/user-generation-rust"
	@echo "  - curl http://localhost:3000/user-generation-go"
	@echo "  - curl http://localhost:3000/user-generation-js"
	@echo "  - curl http://localhost:3000/user-generation-python"
	@echo "  - curl http://localhost:3000/user-generation-ruby"

.PHONY: run-with-mount
run-with-mount: stop image
	docker run --rm -d --name docker-wws \
	  -p 3000:3000 \
	  --runtime=io.containerd.wws.v1 \
	  --platform=wasi/wasm \
	  -v $(PWD)/tmp:/tmp \
	  -v $(PWD)/tmp:/user-generation-python/tmp \
	  -v $(PWD)/tmp:/user-generation-ruby/tmp \
	  wws-apps:latest
	@echo "Now you can reach the Wasm Workers Server functions, such as:"
	@echo "  - curl http://localhost:3000/user-generation-rust"
	@echo "  - curl http://localhost:3000/user-generation-go"
	@echo "  - curl http://localhost:3000/user-generation-js"
	@echo "  - curl http://localhost:3000/user-generation-python"
	@echo "  - curl http://localhost:3000/user-generation-ruby"

.PHONY: build
build: image dist;

.PHONY: stop
stop:
	docker rm -f docker-wws

.PHONY: clean
clean:
	rm -Rf ./dist
