#!/bin/sh
FILE=/config/snapserver.conf
if test -f "$FILE"; then
    echo "$FILE exists, copying to config folder."
    cp $FILE /etc/snapserver.conf
fi

export DBUS_SESSION_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket
# nqptp &
# rc-service dbus start
dbus-daemon --system
avahi-daemon &
# rc-service shairport-sync zap
snapserver