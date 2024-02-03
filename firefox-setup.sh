#!/bin/bash

echo "Setting up Firefox..."

# Firefox uses a randomly-generated string as part of the config directory name for some reason
randomized_part=$(find "$HOME/.mozilla/firefox/" -maxdepth 1 -type d -name '*default-release' | grep -oP '([^/]+)\.default-release')

if [ -n "$randomized_part" ]; then
  echo "Randomized part of the directory name: $randomized_part"
else
  echo "Error: No matching directory found."
fi

ffox_dir="$HOME/.mozilla/firefox/$randomized_part"

echo "Linking Firefox configs..."

rm -rf "$ffox_dir/chrome"
ln -s ~/.dotfiles/firefox/default-release/chrome "$ffox_dir/"

rm "$ffox_dir/user.js"
ln -s ~/.dotfiles/firefox/default-release/user.js "$ffox_dir/"

unset randomized_part
unset ffox_dir

echo "Done!"

