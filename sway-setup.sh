#!/bin/bash

# NOTE: The configs depend on JetBrainsMono Nerd Font being installed on the system

color_off='\033[0m'
red='\033[0;31m'
green='\033[0;32m'
yellow_b='\033[1;33m'

echo "Setting up sway..."

declare -a programs=(sway foot waybar wofi swaybg mako grim slurp kanshi)

# Check if all of those programs are installed
for i in "${programs[@]}"
do
  ./check-installed $i
done

rm -rf "$HOME/.config/sway"
ln -s "$HOME/.dotfiles/.config/sway" "$HOME/.config/"

rm -rf "$HOME/.config/waybar"
ln -s "$HOME/.dotfiles/.config/waybar" "$HOME/.config/"

rm -rf "$HOME/.config/foot"
ln -s "$HOME/.dotfiles/.config/foot" "$HOME/.config/"

rm -rf "$HOME/.config/wofi"
ln -s "$HOME/.dotfiles/.config/wofi" "$HOME/.config/"

printf "${green}sway setup complete.${color_off}\n"

echo "Press Win+Shift+C to restart sway"

unset color_off
unset red
unset green
unset yellow_b

