#!/bin/bash

# NOTE: The configs depend on JetBrainsMono Nerd Font being installed on the system

color_off='\033[0m'
red='\033[0;31m'
green='\033[0;32m'
yellow_b='\033[1;33m'

echo "Setting up Sway..."

declare -a programs=(sway foot waybar wofi swaybg mako grim slurp kanshi)

for i in "${programs[@]}"
do
  ./check-installed $i
done

# sudo dnf install sway waybar brightnessctl pulseaudio-utils wofi -y

# waybar: Alternative, more customizable statusbar for Wayland
# brightnessctl: Utility to control screen brightness. Used by sway/config
# pulseaudio-utils: Utility to control pulseaudio settings. Used by sway/config (provides pactl)
# wofi: Fuzzy finder

echo "Linking configs..."

rm -rf "$HOME/.config/sway"
ln -s "$HOME/.dotfiles/.config/sway" "$HOME/.config/"

rm -rf "$HOME/.config/waybar"
ln -s "$HOME/.dotfiles/.config/waybar" "$HOME/.config/"

rm -rf "$HOME/.config/foot"
ln -s "$HOME/.dotfiles/.config/foot" "$HOME/.config/"

rm -rf "$HOME/.config/wofi"
ln -s "$HOME/.dotfiles/.config/wofi" "$HOME/.config/"

echo -e "${green}sway setup complete.${color_off}"

echo "Press Win+Shift+C to restart Sway"

