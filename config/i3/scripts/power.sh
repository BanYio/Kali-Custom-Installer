#!/usr/bin/env bash

CHOICE=$(printf "  Logout\n  Reboot\n⏻  Poweroff" | \
  rofi -dmenu -p "Power" -theme ~/.config/rofi/power.rasi)

case "$CHOICE" in
  *Logout*)  i3-msg exit ;;
  *Reboot*)  systemctl reboot ;;
  *Poweroff*) systemctl poweroff ;;
esac
