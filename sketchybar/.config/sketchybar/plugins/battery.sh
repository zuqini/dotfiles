#!/bin/sh

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

case "${PERCENTAGE}" in
  9[6-9]|100) ICON="󰁹"
  ;;
  9[0-5]|8[6-9]) ICON="󰂂"
  ;;
  8[0-5]|7[6-9]) ICON="󰂁"
  ;;
  7[0-5]|6[6-9]) ICON="󰂀"
  ;;
  6[0-5]|5[6-9]) ICON="󰁿"
  ;;
  5[0-5]|4[6-9]) ICON="󰁾"
  ;;
  4[0-5]|3[6-9]) ICON="󰁽"
  ;;
  3[0-5]|2[6-9]) ICON="󰁼"
  ;;
  2[0-5]|1[6-9]) ICON="󰁻"
  ;;
  1[0-5]|[6-9]) ICON="󰁺"
  ;;
  *) ICON="󰂎"
esac

if [[ "$CHARGING" != "" ]]; then
  ICON="󰂄"
fi

# The item invoking this script (name $NAME) will get its icon and label
# updated with the current battery status
sketchybar --set "$NAME" icon="$ICON" label="${PERCENTAGE}%"
