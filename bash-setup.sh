#!/bin/bash

echo "Linking Bash Scripts..."

rm -rf ~/.bashrc.d
ln -s ~/.dotfiles/.bashrc.d/ ~/

echo "Done!"

