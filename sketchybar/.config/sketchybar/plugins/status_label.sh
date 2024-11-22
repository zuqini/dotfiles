#!/bin/sh

STATUS_LABEL="$(lsappinfo -all info -only StatusLabel $1 | sed -nr 's/\"StatusLabel\"=\{ \"label\"=\"(.+)\" \}$/\1/p')"
if [ -z "${STATUS_LABEL}" ]; then
    sketchybar --set "$NAME" label="$STATUS_LABEL" drawing=off
else
    sketchybar --set "$NAME" label="$STATUS_LABEL" drawing=on
fi
