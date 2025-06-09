#!/bin/sh

ip="$(ip route get 1.1.1.1 2>/dev/null | grep -oP 'src \K[0-9.]+')"

if [ -n "$ip" ]; then
  printf "<icon>computer-fail-symbolic</icon>\n"
  printf "<txt>%s</txt>\n" "$ip"
  if command -v xclip >/dev/null 2>&1; then
    printf "<iconclick>sh -c 'printf %s | xclip -selection clipboard'</iconclick>\n" "$ip"
    printf "<txtclick>sh -c 'printf %s | xclip -selection clipboard'</txtclick>\n" "$ip"
    printf "<tool>Local IP (click to copy)</tool>\n"
  else
    printf "<tool>Local IP (install xclip to copy)</tool>\n"
  fi
else
  printf "<txt>No IP</txt>\n"
fi
