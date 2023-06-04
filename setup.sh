#!/usr/bin/bash

echo "Creating symlinks..."

ln -s ~/.dotfiles/.config/nvim/ ~/.config/
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig

echo "Done!"

