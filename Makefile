IMAGE    := davidforster/github-pages
VERSION  := $(shell grep 'GITHUB_PAGES_VERSION=' Dockerfile | head -1 | sed 's/.*GITHUB_PAGES_VERSION="\(.*\)".*/\1/')

.PHONY: build push push-latest

build:
	docker build -t $(IMAGE):$(VERSION) -t $(IMAGE):latest .

push: build
	docker push $(IMAGE):$(VERSION)
	docker push $(IMAGE):latest

push-latest: build
	docker push $(IMAGE):latest
