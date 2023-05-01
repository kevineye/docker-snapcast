DOCKER_IMAGE=snapcast
DOCKER_REPO=daredoes

build:
	docker build --platform=linux/amd64 -t $(DOCKER_REPO)/$(DOCKER_IMAGE) .
	# docker build --platform=linux/arm64 -t $(DOCKER_REPO)/$(DOCKER_IMAGE) .

push:
	docker tag $(DOCKER_REPO)/$(DOCKER_IMAGE) $(DOCKER_REPO)/$(DOCKER_IMAGE):latest
	docker push $(DOCKER_REPO)/$(DOCKER_IMAGE):latest

.PHONY: build push
