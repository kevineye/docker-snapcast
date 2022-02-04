FROM alpine:edge

WORKDIR /data

RUN apk -U add librespot snapcast-server
