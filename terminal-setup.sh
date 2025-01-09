#!/bin/sh

color_off='\033[0m'
red='\033[0;31m'
green='\033[0;32m'
yellow_b='\033[1;33m'

echo "Setting up ghostty..."

./check-installed ghostty

rm -rf "$HOME/.config/ghostty"
ln -s "$HOME/.dotfiles/.config/ghostty" "$HOME/.config/"

printf "${green}ghostty setup complete.${color_off}\n"

unset color_off
unset red
unset green
unset yellow_b

