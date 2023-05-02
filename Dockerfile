FROM alpine:edge


WORKDIR /data
WORKDIR /config

EXPOSE 1704
EXPOSE 1705
EXPOSE 1780

RUN apk add --no-cache avahi
RUN apk add autoconf automake build-base linux-headers git && git clone https://github.com/mikebrady/nqptp.git &&  cd nqptp &&  autoreconf -fi &&  ./configure --with-systemd-startup && make && make install && rm -rf nqptp && apk del autoconf automake build-base linux-headers git

 
RUN apk add --no-cache librespot --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/
RUN apk add --no-cache shairport-sync --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/
RUN apk add -u snapcast
# # Need to run `sh /start.sh` on server start manually

# RUN adduser -D myuser abuild
# RUN adduser myuser abuild
# RUN apk add alpine-sdk 
# USER myuser
# RUN mkdir ~/shairport-sync
# COPY ./shairport-sync/APKBUILD /home/myuser/shairport-sync/APKBUILD
# COPY ./shairport-sync/shairport-sync.initd /home/myuser/shairport-sync/shairport-sync.initd
# RUN cd ~/shairport-sync && abuild-keygen -a -n
# USER root
# RUN cp /home/myuser/.abuild/* /etc/apk/keys/
# USER myuser
# RUN cd ~/shairport-sync && abuild -r
# USER root
# RUN apk del alpine-sdk
# RUN apk add /home/myuser/packages/myuser/x86_64/*.apk --allow-untrusted 


COPY ./config/snapserver.conf /etc
COPY ./snapweb/dist/* /usr/share/snapserver/snapweb/
COPY ./start.sh /
RUN chmod +x /start.sh

ENTRYPOINT [ "/start.sh" ]