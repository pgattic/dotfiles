#!/bin/bash

# NOTE: The configs depend on JetBrainsMono Nerd Font being installed on the system

color_off='\033[0m'
red='\033[0;31m'
green='\033[0;32m'
yellow_b='\033[1;33m'

echo "Setting up gtk..."

rm -rf "$HOME/.config/gtk-3.0"
ln -s "$HOME/.dotfiles/.config/gtk-3.0" "$HOME/.config/"

printf "${green}gtk setup complete.${color_off}\n"

unset color_off
unset red
unset green
unset yellow_b

