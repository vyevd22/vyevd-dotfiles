#!/bin/bash
chosen=$(echo -e "⏻  Shutdown\n  Reboot\n  Suspend\n  Logout" | rofi -dmenu -p "")
case $chosen in
    "⏻  Shutdown") systemctl poweroff ;;
    "  Reboot") systemctl reboot ;;
    "  Suspend") systemctl suspend ;;
    "  Logout") hyprctl dispatch exit ;;
esac