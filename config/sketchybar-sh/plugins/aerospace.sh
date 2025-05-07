#!/usr/bin/env zsh

# Ensure aerospace CLI is available
if ! command -v aerospace &> /dev/null; then
  echo "Error: aerospace CLI not found!"
  exit 1
fi

# Icons for workspaces (adjust as needed)
# Using numbers here, but you could map names to icons if preferred
ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")
# You could use Nerd Font icons like:
# ICONS=("󰲠" "󰲢" "󰲤" "󰲦" "󰲨" "󰲪" "󰲬" "󰲮" "󰲰" "󰲲")

# Colors
FOCUSED_COLOR="0xafb9f3fb" # Example focused color (peach) - Make sure this matches $PEACH or your desired color
VISIBLE_COLOR="0xffffffff" # Example visible color (white)
DEFAULT_COLOR="0xff9a9a9a" # Example default color (grey)

# Get workspace data (Removed 'cli')
WORKSPACES_DATA=$(aerospace list-workspaces --all)
FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)

args=()
index=0
while IFS= read -r line; do
  # Skip empty lines if any
  [[ -z "$line" ]] && continue

  # In Aerospace v0.10.0+, the format is just the name per line.
  # We need to check if it's the focused one separately.
  name="$line"
  icon="${ICONS[$index]:-$name}" # Use number icon or name if out of bounds
  color="$DEFAULT_COLOR"

  if [[ "$name" == "$FOCUSED_WORKSPACE" ]]; then
    color="$FOCUSED_COLOR"
  fi

  # Add space item to sketchybar arguments
  # Ensure the item name 'space.$((index + 1))' matches what's in items/spaces.sh
  args+=(--set space.$((index + 1)) background.color="$color" icon="$icon")
  ((index++))
done <<< "$WORKSPACES_DATA"

# Update sketchybar
# The lock file error will appear here if sketchybar is running, but it's okay.
# When run by sketchybar itself, this command will work.
sketchybar "${args[@]}" --trigger aerospace_update # Added a trigger for potential debugging/logging
