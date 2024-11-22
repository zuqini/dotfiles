#!/bin/sh

STATUS_LABEL="$(lsappinfo -all info -only StatusLabel $1 | sed -nr 's/\"StatusLabel\"=\{ \"label\"=\"(.+)\" \}$/\1/p')"
sketchybar --set "$NAME" label="$STATUS_LABEL"
