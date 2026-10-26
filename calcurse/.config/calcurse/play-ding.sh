#!/usr/bin/env bash
# play the ding for incoming notifications.
# skipped entirely while Do Not Disturb is on.
if [ "$(swaync-client --get-dnd 2>/dev/null)" = "true" ]; then
    exit 0
fi
paplay --volume=60000 "$HOME/.config/calcurse/notify-ding.wav"
date +%T >> /tmp/swaync-ding.log
