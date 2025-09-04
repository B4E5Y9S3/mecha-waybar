#!/bin/bash

# Configuration
STATUS_FILE="$HOME/.config/waybar/audio_output_status"

# Get sink ID and name
SINK_INFO=$(pactl list short sinks | grep analog-stereo)
SINK_ID=$(echo "$SINK_INFO" | awk '{print $1}')
SINK_NAME=$(echo "$SINK_INFO" | awk '{print $2}')

# Get current port using the method that works for you
CURRENT_PORT=$(pactl list sinks | grep -A20 "$SINK" | grep "Active Port" | awk '{print $3}')

# Define port names
HEADPHONES_PORT="analog-output-headphones"
LINEOUT_PORT="analog-output-lineout"

# Toggle between ports
if [ "$CURRENT_PORT" = "$HEADPHONES_PORT" ]; then
    pactl set-sink-port "$SINK_ID" "$LINEOUT_PORT"
    echo "Line Out" > "$STATUS_FILE"
    notify-send "Audio output switched to Line Out"
elif [ "$CURRENT_PORT" = "$LINEOUT_PORT" ]; then
    pactl set-sink-port "$SINK_ID" "$HEADPHONES_PORT"
    echo "Headphones" > "$STATUS_FILE"
    notify-send "Audio output switched to Headphones"
else
    # If current port is neither, default to headphones
    pactl set-sink-port "$SINK_ID" "$HEADPHONES_PORT"
    echo "Headphones" > "$STATUS_FILE"
    notify-send "Audio output switched to Headphones"
fi
