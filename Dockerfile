FROM alpine:edge

WORKDIR /data

RUN apk -U add git bash build-base asio-dev avahi-dev flac-dev libvorbis-dev alsa-lib-dev \
 && cd /root \
 && git clone --recursive https://github.com/badaix/snapcast.git \
 && cd snapcast \
 && make \
 && cp server/snapserver client/snapclient /usr/local/bin \
 && cd / \
 && apk --purge del git bash build-base asio-dev bash avahi-dev flac-dev libvorbis-dev alsa-lib-dev \
 && apk add avahi-libs flac libvorbis alsa-lib \
 && rm -rf /etc/ssl /var/cache/apk/* /lib/apk/db/* /root/snapcast
