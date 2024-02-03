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

rm -rf ~/.config/sway
ln -s ~/.dotfiles/.config/sway ~/.config/

rm -rf ~/.config/waybar
ln -s ~/.dotfiles/.config/waybar ~/.config/

rm -rf ~/.config/foot
ln -s ~/.dotfiles/.config/foot ~/.config/

rm -rf ~/.config/fuzzel
ln -s ~/.dotfiles/.config/fuzzel ~/.config/

echo "Done!"
echo "Press Win+Shift+C to restart Sway"

