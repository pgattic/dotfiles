#!/bin/bash

echo "Setting up Firefox..."

color_off='\033[0m'
red='\033[0;31m'
green='\033[0;32m'

# Firefox uses a randomly-generated string as part of the config directory name for some reason
randomized_part=$(find "$HOME/.mozilla/firefox/" -maxdepth 1 -type d -name '*default-release' | grep -oP '([^/]+)\.default-release')

if [ -n "$randomized_part" ]; then
  echo "Randomized part of the directory name: $randomized_part"
  ffox_dir="$HOME/.mozilla/firefox/$randomized_part"

  echo "Linking Firefox configs..."

  rm -rf "$ffox_dir/chrome"
  ln -s "$HOME/.dotfiles/.mozilla/firefox/default-release/chrome" "$ffox_dir/"

  rm "$ffox_dir/user.js"
  ln -s "$HOME/.dotfiles/.mozilla/firefox/default-release/user.js" "$ffox_dir/"

  unset ffox_dir
  echo "${green}Firefox setup - Done.${color_off}"
else
  echo "${red}ERROR${color_off}: No matching directory found. Make sure Firefox is installed as a system package."
fi

echo -e "${green}Firefox setup complete."

unset randomized_part
unset color_off
unset red
unset green

