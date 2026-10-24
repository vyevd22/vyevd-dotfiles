#!/usr/bin/env bash
# calcurse morning digest — one notification listing today's items.
# (all-day events can't fire the timed daemon warning, so this catches them)
TODAY=$(date +%m/%d/%Y)
AGENDA=$(calcurse -d "$TODAY" 2>/dev/null | head -20)
if [ -n "$AGENDA" ]; then
    notify-send -u normal -t 0 "calcurse — today" "$AGENDA"
fi
