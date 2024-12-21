#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME label.color=0xffafd4de label.font.style=Heavy
else
    sketchybar --set $NAME label.color=0xff587b7b label.font.style=Regular
fi
