#!/bin/bash

# NOTE: The configs depend on JetBrainsMono Nerd Font being installed on the system

color_off='\033[0m'
red='\033[0;31m'
green='\033[0;32m'
yellow_b='\033[1;33m'

echo "Setting up hyprland..."

declare -a programs=(Hyprland alacritty waybar fuzzel swaybg mako grim slurp)

# Check if all of those programs are installed
for i in "${programs[@]}"
do
  ./check-installed $i
done

rm -rf "$HOME/.config/hypr"
ln -s "$HOME/.dotfiles/.config/hypr" "$HOME/.config/"

rm -rf "$HOME/.config/waybar"
ln -s "$HOME/.dotfiles/.config/waybar" "$HOME/.config/"

rm -rf "$HOME/.config/alacritty"
ln -s "$HOME/.dotfiles/.config/alacritty" "$HOME/.config/"

rm -rf "$HOME/.config/fuzzel"
ln -s "$HOME/.dotfiles/.config/fuzzel" "$HOME/.config/"

# rm -rf "$HOME/.config/kanshi"
# ln -s "$HOME/.dotfiles/.config/kanshi" "$HOME/.config/"

printf "${green}hyprland setup complete.${color_off}\n"

unset color_off
unset red
unset green
unset yellow_b

