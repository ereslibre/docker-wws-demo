.PHONY: run
run: stop build
	docker run \
	  --name docker-wws \
	  -d \
	  -p 3000:3000 \
	  -v /etc/ssl:/etc/ssl \
	  --runtime=io.containerd.wws.v1 \
	  --platform=wasi/wasm \
	  apps:latest
	echo "Now you can reach the Wasm Workers Server functions, such as:"
	echo "  - curl http://localhost:3000/user-generation-rust"
	echo "  - curl http://localhost:3000/user-generation-go"
	echo "  - curl http://localhost:3000/user-generation-js"
	echo "  - curl http://localhost:3000/user-generation-python"
	echo "  - curl http://localhost:3000/user-generation-ruby"

.PHONY: run-with-mount
run-with-mount: stop build
	docker run \
	  --name docker-wws \
	  -d \
	  -p 3000:3000 \
	  -v /etc/ssl:/etc/ssl \
	  -v $(PWD)/tmp:/tmp \
	  -v $(PWD)/tmp:/user-generation-python/tmp \
	  -v $(PWD)/tmp:/user-generation-ruby/tmp \
	  --runtime=io.containerd.wws.v1 \
	  --platform=wasi/wasm \
	  apps:latest
	echo "Now you can reach the Wasm Workers Server functions, such as:"
	echo "  - curl http://localhost:3000/user-generation-rust"
	echo "  - curl http://localhost:3000/user-generation-go"
	echo "  - curl http://localhost:3000/user-generation-js"
	echo "  - curl http://localhost:3000/user-generation-python"
	echo "  - curl http://localhost:3000/user-generation-ruby"

.PHONY: build
build: apps
	make -C apps all
	docker buildx build --platform wasi/wasm --provenance false -t apps:latest .


.PHONY: stop
stop:
	docker rm -f docker-wws

.PHONY: clean
clean:
	make -C apps clean
