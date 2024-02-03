#!/bin/bash

# NOTE: The configs depend on JetBrainsMono Nerd Font being installed on the system, and this setup script assumes the dnf package manager, connected to the default Fedora Linux repos.

echo "Setting up Sway..."

echo "Installing Sway-related packages..."

sudo dnf install sway waybar brightnessctl pulseaudio-utils fuzzel -y

# waybar: Alternative, more customizable statusbar for Wayland
# brightnessctl: Utility to control screen brightness. Used by sway/config
# pulseaudio-utils: Utility to control pulseaudio settings. Used by sway/config (provides pactl)
# fuzzel: Alternative app launcher that works with Flatpak apps and uses fuzzy finding

echo "Done!"

echo "Linking configs..."

rm -rf "$HOME/.config/sway"
ln -s "$HOME/.dotfiles/.config/sway" "$HOME/.config/"

rm -rf "$HOME/.config/waybar"
ln -s "$HOME/.dotfiles/.config/waybar" "$HOME/.config/"

rm -rf "$HOME/.config/foot"
ln -s "$HOME/.dotfiles/.config/foot" "$HOME/.config/"

rm -rf "$HOME/.config/fuzzel"
ln -s "$HOME/.dotfiles/.config/fuzzel" "$HOME/.config/"

echo "Done!"
echo "Press Win+Shift+C to restart Sway"

