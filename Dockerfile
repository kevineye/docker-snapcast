FROM alpine:edge AS nqptp_builder

WORKDIR /src/nqptp

RUN apk add autoconf automake build-base linux-headers git && git clone https://github.com/mikebrady/nqptp.git /src/nqptp &&  cd /src/nqptp &&  autoreconf -fi &&  ./configure --with-systemd-startup && make && make install && rm -rf nqptp && apk del autoconf automake build-base linux-headers git

RUN cp $(which nqptp) /src/nqptp/nqptp

FROM alpine:edge as builder
WORKDIR /src/shairport
# Copy the nqptp binary from the previous stage
COPY --from=nqptp_builder /src/nqptp/nqptp /usr/local/bin/nqptp

# Install the minimum dependencies required to run the nqptp binary
RUN apk add --no-cache \
    libstdc++ mosquitto-dev libtool alsa-lib-dev popt-dev openssl-dev soxr-dev avahi-dev libplist-dev ffmpeg-dev libsodium-dev libgcrypt-dev xxd


RUN adduser -D myuser abuild
RUN adduser myuser abuild
RUN apk add alpine-sdk
USER myuser
RUN mkdir ~/shairport-sync
COPY ./shairport-sync/APKBUILD /home/myuser/shairport-sync/APKBUILD
COPY ./shairport-sync/shairport-sync.initd /home/myuser/shairport-sync/shairport-sync.initd
RUN cd ~/shairport-sync && abuild-keygen -a -n
USER root
RUN cp /home/myuser/.abuild/* /etc/apk/keys/
USER myuser
RUN cd ~/shairport-sync && abuild -r
USER root
RUN apk del alpine-sdk
RUN apk add /home/myuser/packages/myuser/x86_64/*.apk --allow-untrusted 

RUN cp $(which shairport-sync) /src/shairport/shairport-sync

FROM alpine:edge

# Copy the nqptp binary from the previous stage
COPY --from=nqptp_builder /src/nqptp/nqptp /usr/local/bin/nqptp
COPY --from=builder /src/shairport/shairport-sync /usr/local/bin/shairport-sync

# Install the minimum dependencies required to run the nqptp and shairport binaries
RUN apk add --no-cache \
    libstdc++

RUN apk add --no-cache libconfig-dev popt-dev mosquitto-dev libtool alsa-lib-dev popt-dev openssl-dev soxr-dev avahi-dev libplist-dev ffmpeg-dev libsodium-dev libgcrypt-dev xxd

WORKDIR /data
WORKDIR /config

EXPOSE 1704
EXPOSE 1705
EXPOSE 1780


RUN apk add --no-cache avahi

 
RUN apk add --no-cache librespot --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/
RUN apk add -u snapcast

RUN apk add dbus
RUN apk add python3 py3-pip
RUN pip install websockets websocket-client

COPY ./config/snapserver.conf /etc
COPY ./snapweb/dist/* /usr/share/snapserver/snapweb/
COPY ./start.sh /
RUN chmod +x /start.sh
RUN export DBUS_SESSION_BUS_ADDRESS=unix:path=/var/run/dbus/system_bus_socket

ENTRYPOINT ["/start.sh" ]