#!/bin/sh
FILE=/config/snapserver.conf
if test -f "$FILE"; then
    echo "$FILE exists, copying to config folder."
    cp $FILE /etc/snapserver.conf
fi
nqptp &
rc-service dbus start
rc-service avahi-daemon start
snapserver