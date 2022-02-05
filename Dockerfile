FROM alpine:edge

WORKDIR /data

EXPOSE 1704
EXPOSE 1705
EXPOSE 1780
COPY ./snapserver.conf /etc
COPY ./start.sh /
RUN apk add librespot --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/
RUN apk -U add bash snapcast
# Need to run `sh /start.sh` on server start manually