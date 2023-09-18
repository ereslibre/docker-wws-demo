.PHONY: image
image:
	docker build --platform wasi/wasm --provenance=false --tag=wws-apps:latest .

.PHONY: dist
dist: clean
	docker build --platform wasi/wasm --provenance=false --output=dist .

.PHONY: image-wws
image-wws:
	docker build --target=base --tag=wws-bin:latest .

.PHONY: run-dev
run-dev: stop image-wws dist
	docker run --rm -it --name docker-wws \
	  -p 3000:3000 \
	  -p 8080:8080 \
	  -v $(PWD)/dist:/dist \
	  wws-bin:latest \
	  wws --enable-panel --host 0.0.0.0 /dist

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
