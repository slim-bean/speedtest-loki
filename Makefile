IMAGE_NAME ?= slimbean/speedtest-loki
VERSION ?= latest

.PHONY: build-amd64 build-arm64 build-multi-arch push clean

# Build for AMD64
build-amd64:
	docker build --platform linux/amd64 -t $(IMAGE_NAME):amd64-$(VERSION) .

# Build for ARM64
build-arm64:
	docker build --platform linux/arm64 -t $(IMAGE_NAME):arm64-$(VERSION) .

# Build multi-architecture image
build-multi-arch:
	docker buildx build --platform linux/amd64,linux/arm64 \
		-t $(IMAGE_NAME):$(VERSION) \
		--push .

# Push all images
push: build-multi-arch

# Clean up local images
clean:
	docker rmi $(IMAGE_NAME):amd64-$(VERSION) $(IMAGE_NAME):arm64-$(VERSION) || true

# Default target
all: build-multi-arch 