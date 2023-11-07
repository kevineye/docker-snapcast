FROM rust:slim-buster as builder
RUN apt-get update && apt-get install -y curl build-essential cmake git
RUN git clone https://github.com/badaix/snapcast.git
RUN apt-get install -y libboost-all-dev libasound2-dev libpulse-dev libvorbisidec-dev libvorbis-dev libopus-dev libflac-dev libsoxr-dev alsa-utils libavahi-client-dev avahi-daemon libexpat1-dev
COPY ./snapserver_0.27.0-1_amd64.deb /snapserver_amd64.deb
RUN apt-get install -y autoconf libpopt-dev libconfig-dev libssl-dev build-essential libavahi-client-dev /snapserver_amd64.deb \
 && set -eux; \
    curl -fsSL "https://api.github.com/repos/mikebrady/shairport-sync/releases/latest" | grep -oP '"tag_name": "\K(.*)(?=")' | xargs -I {} curl -fsSL "https://github.com/mikebrady/shairport-sync/archive/{}.tar.gz" -o shairport-sync.tar.gz; \
    tar -xzf shairport-sync.tar.gz; \
    cd shairport-sync-*; \
    autoreconf -i -f; \
    ./configure --with-stdout --with-avahi --with-ssl=openssl --with-metadata; \
    make; \
    cp shairport-sync /usr/local/bin/; \
    cd ..; \
    rm -rf shairport-sync* && \
    # apt-get remove -y curl autoconf libpopt-dev libconfig-dev libssl-dev build-essential libavahi-client-dev && \
    # apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN update-rc.d shairport-sync remove || true

# Build and install librespot
RUN git clone https://github.com/librespot-org/librespot.git
RUN cd librespot && cargo build --release
RUN cp /librespot/target/release/librespot /usr/local/bin/

FROM debian:bullseye-slim

# Install Python dependencies including pip and websockets
COPY ./snapserver_0.27.0-1_amd64.deb /snapserver_amd64.deb
RUN apt-get update && apt-get install -y unzip python3-pip curl git nano libboost-all-dev libasound2-dev libpulse-dev libvorbisidec-dev libvorbis-dev libopus-dev libflac-dev libsoxr-dev alsa-utils libavahi-client-dev avahi-daemon libexpat1-dev libpopt-dev libconfig-dev libssl-dev build-essential /snapserver_amd64.deb

RUN python3 -m pip install websockets websocket-client
# RUN npm install --global yarn
# RUN export NVM_DIR="$HOME/.nvm"
# RUN curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash 
# RUN echo "[[ -s $HOME/.nvm/nvm.sh ]] && . $HOME/.nvm/nvm.sh" >> $HOME/.bashrc;
# RUN git clone https://github.com/daredoes/snapweb
# WORKDIR /snapweb
# RUN git checkout vite-to-gatsby
# RUN bash -i -c 'nvm install && nvm use && yarn && yarn build'
# RUN cp -r public/* /usr/share/snapserver/snapweb

## Download snapweb compiled from github
RUN mkdir /tmp/snapweb && rm -rf /usr/share/snapserver/snapweb &&  mkdir /usr/share/snapserver/snapweb && cd /tmp/snapweb && \
    curl -LJO https://github.com/daredoes/snapweb/releases/download/v0.4.1/dist.zip && \
    unzip dist.zip -d /usr/share/snapserver/snapweb && cd / && \
    rm -rf /tmp/snapweb

WORKDIR /data
WORKDIR /config

EXPOSE 1704
EXPOSE 1705
EXPOSE 1780



COPY --from=builder /librespot/target/release/librespot /usr/local/bin/
COPY --from=builder /usr/local/bin/shairport-sync /usr/local/bin/
COPY ./config/snapserver.conf /etc
COPY ./start.sh /
RUN chmod +x /start.sh


ENTRYPOINT [ "/start.sh" ]