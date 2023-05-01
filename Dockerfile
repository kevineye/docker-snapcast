FROM mikebrady/shairport-sync


WORKDIR /data
WORKDIR /config
WORKDIR /var/run/dbus

EXPOSE 1704
EXPOSE 1705
EXPOSE 1780

RUN apk add autoconf automake build-base linux-headers 
RUN apk add -U git
RUN apk add avahi
RUN git clone https://github.com/mikebrady/nqptp.git
RUN cd nqptp &&  autoreconf -fi &&  ./configure --with-systemd-startup && make && make install
RUN rm -rf nqptp
RUN apk del autoconf automake build-base linux-headers

 
RUN apk add librespot --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/
# RUN apk add shairport-sync --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/
RUN apk add -u snapcast
# # Need to run `sh /start.sh` on server start manually
# RUN apk add alpine-sdk
# RUN apk add wget
# # RUN mkdir /home/shairport-sync && cd /home/shairport-sync && wget https://git.alpinelinux.org/aports/plain/testing/shairport-sync/APKBUILD && wget https://git.alpinelinux.org/aports/plain/testing/shairport-sync/shairport-sync.initd
# RUN adduser -D myuser abuild
# RUN adduser myuser abuild
# USER myuser
# RUN mkdir ~/shairport-sync
# COPY ./shairport-sync/APKBUILD /home/myuser/shairport-sync/APKBUILD
# COPY ./shairport-sync/shairport-sync.initd /home/myuser/shairport-sync/shairport-sync.initd
# RUN ls ~/shairport-sync | echo
# RUN cd ~/shairport-sync && abuild-keygen -a -n
# USER root
# RUN cp /home/myuser/.abuild/* /etc/apk/keys/
# USER myuser
# RUN cd ~/shairport-sync && abuild -r
# USER root
# RUN apk add /home/myuser/packages/myuser/x86_64/*.apk --allow-untrusted 
RUN apk add openrc
RUN apk add avahi-tools
RUN apk add dbus


COPY ./config/snapserver.conf /etc
COPY ./snapweb/dist/* /usr/share/snapserver/snapweb/
COPY ./start.sh /
RUN chmod +x /start.sh

ENTRYPOINT [ "/start.sh" ]