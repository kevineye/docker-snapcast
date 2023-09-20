#!/bin/sh
FILE=/config/snapserver.conf
if test -f "$FILE"; then
    echo "$FILE exists, copying to config folder."
    cp $FILE /etc/snapserver.conf
fi


# nqptp &
# rc-service dbus start

export DBUS_SYSTEM_BUS_ADDRESS=`dbus-daemon --fork --config-file=/usr/share/dbus-1/session.conf --print-address`
# export DBUS_SYSTEM_BUS_ADDRESS=`dbus-daemon --system --nofork --nopidfile --print-address`
avahi-daemon &
nqptp &
# rc-service shairport-sync zap
snapserver