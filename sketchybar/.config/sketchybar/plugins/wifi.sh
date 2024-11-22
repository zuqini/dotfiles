#!/bin/sh

# The wifi_change event supplies a $INFO variable in which the current SSID
# is passed to the script.
INFO="$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}' | xargs networksetup -getairportnetwork | sed "s/Current Wi-Fi Network: //")"
if [ "$SENDER" = "wifi_change" ]; then
  if [[ $INFO = *"You are not associated with an AirPort network."* ]]; then
      sketchybar --set $NAME label="Not Connected"
  else
      sketchybar --set $NAME label="${INFO}"
  fi
fi
