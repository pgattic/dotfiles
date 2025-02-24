#!/bin/sh

color_off='\033[0m'
red='\033[0;31m'
green='\033[0;32m'
yellow_b='\033[1;33m'

echo "Setting up kitty..."

./check-installed kitty

rm -rf "$HOME/.config/kitty"
ln -s "$HOME/.dotfiles/.config/kitty" "$HOME/.config/"

printf "${green}kitty setup complete.${color_off}\n"

unset color_off
unset red
unset green
unset yellow_b

