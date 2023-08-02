user-generation-go.wasm: main.go
	docker rm -f build-$@
	docker run --name build-$@ -v $(shell pwd):/src tinygo/tinygo:0.28.1 sh -c "cd /src; tinygo build -o /home/tinygo/$@ -target=wasi ."
	docker cp build-$@:/home/tinygo/$@ ./$@
	docker rm -f build-$@
