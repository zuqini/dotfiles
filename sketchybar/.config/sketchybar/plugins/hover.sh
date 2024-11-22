#!/bin/sh

if [ "$SENDER" = "mouse.exited" ]; then
  sketchybar -m --set $NAME background.drawing=off
fi

if [ "$SENDER" = "mouse.entered" ]; then
  sketchybar -m --set $NAME background.drawing=on
fi
