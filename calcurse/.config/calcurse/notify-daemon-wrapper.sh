#!/usr/bin/env bash
# calcurse notification daemon wrapper.
# the daemon is designed to exit whenever the TUI is (re)entered — by design!
# so: wait for any interactive calcurse to exit, then run the daemon.
# with systemd Restart=always this gives: daemon always alive, except while
# the TUI is actually open (where in-TUI warnings cover it anyway).

PIDFILE="$HOME/.local/share/calcurse/.calcurse.pid"

while pgrep -x calcurse >/dev/null 2>&1; do
    sleep 15
done

# stale lock cleanup: if the pid file names a process that is NOT calcurse
# (dead TUI + pid number recycled by some unrelated process), remove it —
# otherwise calcurse --daemon aborts with "calcurse is running".
if [ -f "$PIDFILE" ]; then
    owner_comm=$(ps -p "$(cat "$PIDFILE")" -o comm= 2>/dev/null)
    if [ "$owner_comm" != "calcurse" ]; then
        rm -f "$PIDFILE"
    fi
fi

exec calcurse --daemon
