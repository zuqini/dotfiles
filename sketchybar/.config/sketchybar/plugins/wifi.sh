#!/bin/sh

# The wifi_change event supplies a $INFO variable in which the current SSID
# is passed to the script.
if [ "$SENDER" = "wifi_change" ]; then
  IP_SUMMARY_INFO="$(ipconfig getsummary en0 | awk -F ' SSID : '  '/ SSID : / {print $2}')"
  if [[ $IP_SUMMARY_INFO = "" ]]; then
      sketchybar --set $NAME label="Not Connected"
  elif [[ $IP_SUMMARY_INFO = *"<redacted>"* ]]; then
      # special case for when IP_SUMMARY_INFO is redacted
      NETWORK_SETUP_INFO="$(networksetup -listpreferredwirelessnetworks en0 | sed -n '2p' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
      sketchybar --set $NAME label="$NETWORK_SETUP_INFO"
  else
      sketchybar --set $NAME label="$IP_SUMMARY_INFO"
  fi
fi
