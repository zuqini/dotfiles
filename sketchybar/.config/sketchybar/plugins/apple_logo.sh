#!/bin/sh

if [ "$SENDER" = "mouse.exited.global" ]; then
  sketchybar -m --set $NAME popup.drawing=off
fi

if [ "$SENDER" = "mouse.entered" ]; then
  sketchybar -m --set $NAME popup.drawing=on
fi
