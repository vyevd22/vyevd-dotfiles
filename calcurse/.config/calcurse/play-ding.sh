#!/usr/bin/env bash
paplay --volume=65535 "$HOME/.config/calcurse/notify-ding.wav"
date +%T >> /tmp/swaync-ding.log
