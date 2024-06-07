#!/bin/bash

color_off='\033[0m'
red='\033[0;31m'
green='\033[0;32m'
yellow_b='\033[1;33m'

echo "Setting up bash..."

rm -rf "$HOME/.bashrc.d"
ln -s "$HOME/.dotfiles/.bashrc.d/" "$HOME/"

echo -e "${green}bash setup complete.${color_off}"

unset color_off
unset red
unset green
unset yellow_b

