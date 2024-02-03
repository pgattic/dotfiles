#!/bin/bash

echo "Hooking up dotfiles..."

echo "Removing local copies..."

# Remove current copies of the dotfiles
# (Note to future self: both of these commands are link-agnostic i.e. they remove the specified copy of the file/directory regardless of if they are a link or a file, leaving any source files untouched)
rm -rf ~/.config/nvim
unlink ~/.gitconfig

echo "Creating symlinks..."

# ln -s means symbolic link, and it applies to both directories and files.
ln -s ~/.dotfiles/.config/nvim/ ~/.config/
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig

echo "[Nvim] Installing Nerd Font..."

cp JetBrainsMonoNerdFont-Regular.ttf ~/.local/share/fonts/
fc-cache -f -v

echo "Done!"
echo '[Nvim] Make sure to set your terminal font to "Hack Nerd Font"!'

