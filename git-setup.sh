#!/bin/bash

color_off='\033[0m'
red='\033[0;31m'
green='\033[0;32m'
yellow_b='\033[1;33m'

echo "Setting up git..."

./check-installed git

# Remove current copies of the dotfiles
# (Note to future self: both of these commands work whether there is a pre-existing link, or a pre-existing directory/file)
unlink "$HOME/.gitconfig"

# ln -s means symbolic link, and it applies to both directories and files.
ln -s "$HOME/.dotfiles/.gitconfig" "$HOME/.gitconfig"

echo -e "${green}git setup complete.${color_off}"

unset color_off
unset red
unset green
unset yellow_b

