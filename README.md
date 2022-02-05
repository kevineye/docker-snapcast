This container packages [Snapcast](https://github.com/badaix/snapcast), a multi-room client-server audio player, where all clients are time synchronized with the server to play perfectly synced audio. It's not a standalone player, but an extension that turns your existing audio player into a Sonos-like multi-room solution.

This container includes both snapserver, the broadcaster, and snapclient, the receiver. snapserver distributes audio read from a pipe. snapserver plays audio from snapserver into alsa, pulseaudio, or portaudio.

### Examples

Broadcast audio from /tmp/pcm-pipe:

    docker run -d \
        -v /tmp/pcm-pipe:/data/snapfifo \
        -p 1704:1704 \
        -p 1705:1705 \
        daredoes/snapcast
        sh /start.sh

### Config

Check the included config in the root of the folder