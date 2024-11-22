#!/bin/sh

if [ "$SENDER" = "mouse.exited.global" ]; then
  sketchybar -m --set $NAME popup.drawing=off
  sketchybar -m --set $NAME background.drawing=off
fi

if [ "$SENDER" = "mouse.entered" ]; then
  sketchybar -m --set $NAME popup.drawing=on
  sketchybar -m --set $NAME background.drawing=on
fi
