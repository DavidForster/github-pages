IMAGE     := davidforster/github-pages
VERSION   := $(shell grep 'GITHUB_PAGES_VERSION=' Dockerfile | head -1 | sed 's/.*GITHUB_PAGES_VERSION="\(.*\)".*/\1/')
PLATFORMS := linux/amd64,linux/arm64

.PHONY: build push push-latest

build:
	docker build -t $(IMAGE):$(VERSION) -t $(IMAGE):latest .

push:
	docker buildx build --platform $(PLATFORMS) --push \
		-t $(IMAGE):$(VERSION) -t $(IMAGE):latest .

push-latest:
	docker buildx build --platform $(PLATFORMS) --push \
		-t $(IMAGE):latest .
