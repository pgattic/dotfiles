#!/bin/bash

echo "Linking Bash Scripts..."

rm -rf "$HOME/.bashrc.d"
ln -s "$HOME/.dotfiles/.bashrc.d/" "$HOME/"

echo "Done!"

