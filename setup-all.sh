#!/bin/sh

echo "Customizing Fedora Packages..."
./dnf-setup.sh

./flatpak-setup.sh

echo "Hooking up dotfiles..."
./setup-dotfiles.sh

