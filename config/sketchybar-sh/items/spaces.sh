#!/usr/bin/env zsh

# Define icons (must match the ones in aerospace.sh or adjust)
SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")
# Or Nerd Font:
# SPACE_ICONS=("󰲠" "󰲢" "󰲤" "󰲦" "󰲨" "󰲪" "󰲬" "󰲮" "󰲰" "󰲲")

# Add individual space items
for i in "${!SPACE_ICONS[@]}"; do
  sid=$((i + 1))
  icon="${SPACE_ICONS[i]}"
  sketchybar --add space space.$sid left \
             --set space.$sid associated_space=$sid \
                            icon="$icon" \
                            icon.padding_left=10 \
                            icon.padding_right=10 \
                            icon.highlight_color="$PEACH" \ # Make sure $PEACH is defined in colors.sh or replace
                            label.drawing=off \
                            background.color="0xff9a9a9a" \
                            background.height=20 \
                            background.corner_radius=5 \
                            script="$PLUGIN_DIR/aerospace.sh" \
                            click_script="aerospace workspace $sid" # Or use workspace name if preferred
done

# Add an item to trigger updates on space changes
sketchybar --add item aerospace_updater left \
           --set aerospace_updater script="$PLUGIN_DIR/aerospace.sh" \
                                   drawing=off \
           --subscribe aerospace_updater space_change front_app_switched display_change


# #!/bin/bash
#
# SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15")
#
# # Destroy space on right click, focus space on left click.
# # New space by left clicking separator (>)
#
# sid=0
# spaces=()
# for i in "${!SPACE_ICONS[@]}"
# do
#   sid=$(($i+1))
#
#   space=(
#     associated_space=$sid
#     icon=${SPACE_ICONS[i]}
#     icon.padding_left=10
#     icon.padding_right=15
#     padding_left=2
#     padding_right=2
#     label.padding_right=20
#     icon.highlight_color=$RED
#     label.font="sketchybar-app-font:Regular:16.0"
#     label.background.height=26
#     label.background.drawing=on
#     label.background.color=$BACKGROUND_2
#     label.background.corner_radius=8
#     label.drawing=off
#     script="$PLUGIN_DIR/space.sh"
#   )
#
#   sketchybar --add space space.$sid left    \
#              --set space.$sid "${space[@]}" \
#              --subscribe space.$sid mouse.clicked
# done
#
# spaces=(
#   background.color=$BACKGROUND_1
#   background.border_color=$BACKGROUND_2
#   background.border_width=2
#   background.drawing=on
# )
#
# separator=(
#   icon=􀆊
#   icon.font="$FONT:Heavy:16.0"
#   padding_left=15
#   padding_right=15
#   label.drawing=off
#   associated_display=active
#   click_script='yabai -m space --create && sketchybar --trigger space_change'
#   icon.color=$WHITE
# )
#
# sketchybar --add bracket spaces '/space\..*/' \
#            --set spaces "${spaces[@]}"        \
#                                               \
#            --add item separator left          \
#            --set separator "${separator[@]}"


