FROM alpine:edge

WORKDIR /data

EXPOSE 1704
EXPOSE 1705
EXPOSE 1780
COPY ./snapserver.conf /etc
RUN apk -U add bash snapcast
# Need to run `snapserver` on server start manually