[![](https://images.microbadger.com/badges/image/kevineye/snapcast.svg)](https://microbadger.com/images/kevineye/snapcast "Get your own image badge on microbadger.com")

This container packages [Snapcast](https://github.com/badaix/snapcast), a multi-room client-server audio player, where all clients are time synchronized with the server to play perfectly synced audio. It's not a standalone player, but an extension that turns your existing audio player into a Sonos-like multi-room solution.

This container includes both snapserver, the broadcaster, and snapclient, the receiver. snapserver distributes audio read from a pipe. snapserver plays audio from snapserver into alsa, pulseaudio, or portaudio.

### Examples

Broadcast audio from /tmp/pcm-pipe:

    docker run -d \
        -v /tmp/pcm-pipe:/data/snapfifo \
        -p 1704:1704 \
        -p 1705:1705 \
        kevineye/snapcast
        snapserver -s pipe:///data/snapfifo?name=Example&sampleformat=44100:16:2

See the included [docker-compose.yml](docker-compose.yml) file for an example of streaming from spotify connect (librespot).