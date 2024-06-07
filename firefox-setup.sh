#!/bin/bash

echo "Setting up firefox..."

color_off='\033[0m'
yellow_b='\033[1;33m'
red='\033[0;31m'
green='\033[0;32m'

# Firefox uses a randomly-generated string as part of the config directory name for some reason
randomized_part=$(find "$HOME/.mozilla/firefox/" -maxdepth 1 -type d -name '*default-release' | grep -oP '([^/]+)\.default-release')

if [ -n "$randomized_part" ]; then
  ffox_dir="$HOME/.mozilla/firefox/$randomized_part"
  printf "[${yellow_b}INFO${color_off}] firefox's config directory for this machine: $ffox_dir\n"

  rm -rf "$ffox_dir/chrome"
  ln -s "$HOME/.dotfiles/.mozilla/firefox/default-release/chrome" "$ffox_dir/"

  rm "$ffox_dir/user.js"
  ln -s "$HOME/.dotfiles/.mozilla/firefox/default-release/user.js" "$ffox_dir/"

  unset ffox_dir
  printf "${green}firefox setup complete.${color_off}\n"
else
  printf "${red}ERROR${color_off}: No matching directory found. Make sure Firefox is installed as a system package.\n"
  printf "${red}firefox setup failed.${color_off}\n"
fi


unset randomized_part
unset color_off
unset yellow_b
unset red
unset green

