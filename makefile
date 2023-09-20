DOCKER_IMAGE=snapcast
DOCKER_REPO=daredoes
TAG_NAME=beta

host-run:
	docker run -d --network host \
    -p 1780:1780 \
    -p 1705:1705 \
    -p 1704:1704 \
    -p 5000:5000 \
    -p 7000:7000 \
    -v /Users/dare/Git/docker-snapcast/myconfig:/config \
    $(DOCKER_REPO)/$(DOCKER_IMAGE)
run:
	docker run -d \
    -p 1780:1780 \
    -p 1705:1705 \
    -p 1704:1704 \
    -p 5000:5000 \
    -p 7000:7000 \
    --privileged \
    -v /Users/dare/Git/docker-snapcast/myconfig:/config \
    $(DOCKER_REPO)/$(DOCKER_IMAGE)


build:
	docker build --platform=linux/amd64 -t $(DOCKER_REPO)/$(DOCKER_IMAGE) . --build-arg SHAIRPORT_SYNC_BRANCH=development --build-arg NQPTP_BRANCH=development --build-arg SNAPCAST_BRANCH=master
	# docker build --platform=linux/arm64 -t $(DOCKER_REPO)/$(DOCKER_IMAGE) .

push:
	docker tag $(DOCKER_REPO)/$(DOCKER_IMAGE) $(DOCKER_REPO)/$(DOCKER_IMAGE):$(TAG_NAME)
	docker push $(DOCKER_REPO)/$(DOCKER_IMAGE):$(TAG_NAME)

.PHONY: build push 
