DOCKER_IMAGE=snapcast
DOCKER_REPO=daredoes
TAG_NAME=stable

run:
	docker run -d \
    -p 1780:1780 \
    -p 1705:1705 \
    -p 1704:1704 \
    -p 319:319 \
    -p 320:320 \
    -p 5000:5000 \
    -p 5001:5001 \
    -p 5002:5002 \
    -p 5003:5003 \
    -p 5004:5004 \
    -p 5005:5005 \
    --privileged \
    -v /Users/dare/Git/docker-snapcast/config:/config \
    $(DOCKER_REPO)/$(DOCKER_IMAGE)


build:
	docker build --platform=linux/amd64 -t $(DOCKER_REPO)/$(DOCKER_IMAGE) .
	# docker build --platform=linux/arm64 -t $(DOCKER_REPO)/$(DOCKER_IMAGE) .

push:
	docker tag $(DOCKER_REPO)/$(DOCKER_IMAGE) $(DOCKER_REPO)/$(DOCKER_IMAGE):$(TAG_NAME)
	docker push $(DOCKER_REPO)/$(DOCKER_IMAGE):$(TAG_NAME)

.PHONY: build push 
