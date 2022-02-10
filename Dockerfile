FROM alpine:edge

WORKDIR /data
WORKDIR /config

EXPOSE 1704
EXPOSE 1705
EXPOSE 1780
COPY ./config/snapserver.conf /etc
COPY ./start.sh /
RUN chmod +x /start.sh
RUN apk add librespot --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/
RUN apk -U add bash snapcast
# Need to run `sh /start.sh` on server start manually
ENTRYPOINT [ "/start.sh" ]