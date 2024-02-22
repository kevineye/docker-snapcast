FROM rust:slim-bookworm as builder
# Install librespot
RUN apt-get update && apt-get install -y curl build-essential cmake git libboost-all-dev libasound2-dev libpulse-dev libvorbisidec-dev libvorbis-dev libopus-dev libflac-dev libsoxr-dev alsa-utils libavahi-client-dev avahi-daemon libexpat1-dev autoconf python3-pip nano python3-websockets libpopt-dev libconfig-dev libssl-dev build-essential libavahi-client-dev vim-nox libplist-dev libsodium-dev libgcrypt-dev libavutil-dev libavcodec-dev libavformat-dev \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN cargo install librespot
RUN git clone https://github.com/mikebrady/nqptp.git /nqptp && cd /nqptp && autoreconf -fi && ./configure --with-systemd-startup && make && cp nqptp /usr/local/bin/nqptp && cd .. && rm -rf nqptp
RUN git clone https://github.com/mikebrady/shairport-sync.git /shairport-sync && cd /shairport-sync && autoreconf -fi && ./configure --sysconfdir=/etc --with-stdout --with-avahi --with-ssl=openssl --with-systemd --with-airplay-2 --with-metadata && make && cp shairport-sync /usr/local/bin/shairport-sync && cd .. && rm -rf shairport-sync
RUN git clone https://github.com/badaix/snapcast.git /snapcast
RUN cd /snapcast && mkdir build && cd build && cmake .. -DBUILD_CLIENT=OFF -DBUILD_SERVER=ON && cmake --build . && cp -r /snapcast/bin/* /usr/local/bin && cd / && rm -rf /snapcast
RUN update-rc.d shairport-sync remove || true
FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y curl libboost-all-dev libasound2-dev libpulse-dev libvorbisidec-dev libvorbis-dev libopus-dev libflac-dev libsoxr-dev alsa-utils libavahi-client-dev avahi-daemon libexpat1-dev python3-pip nano python3-websockets libpopt-dev libconfig-dev libssl-dev build-essential libavahi-client-dev zip \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# Install Python dependencies including pip and websockets


# RUN python3 -m venv venv
# RUN python3 -m pip install websockets websocket-client
# RUN npm install --global yarn
# RUN export NVM_DIR="$HOME/.nvm"
# RUN curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash 
# RUN echo "[[ -s $HOME/.nvm/nvm.sh ]] && . $HOME/.nvm/nvm.sh" >> $HOME/.bashrc;
# RUN git clone https://github.com/daredoes/snapweb
# WORKDIR /snapweb
# RUN git checkout vite-to-gatsby
# RUN bash -i -c 'nvm install && nvm use && yarn && yarn build'


## Download snapweb compiled from github
RUN mkdir /tmp/snapweb && rm -rf /usr/share/snapserver/snapweb &&  mkdir /usr/share/snapserver && mkdir /usr/share/snapserver/snapweb && cd /tmp/snapweb && \
    curl -LJO https://github.com/daredoes/snapweb/releases/download/v0.5.0/dist.zip && \
    unzip dist.zip -d /usr/share/snapserver/snapweb

WORKDIR /data
WORKDIR /config

EXPOSE 1704
EXPOSE 1705
EXPOSE 1780



# COPY --from=builder /librespot/target/release/librespot /usr/local/bin/
COPY ./config/snapserver.conf /etc
COPY ./start.sh /
RUN chmod +x /start.sh

COPY --from=builder /usr/local/bin/shairport-sync /usr/local/bin/shairport-sync
COPY --from=builder /usr/local/bin/snapserver /usr/local/bin/snapserver
COPY --from=builder /usr/local/bin/nqptp /usr/local/bin/nqptp
COPY --from=builder /usr/local/cargo/bin/librespot /usr/local/bin/librespot



ENTRYPOINT [ "/start.sh" ]