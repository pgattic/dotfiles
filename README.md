
# .dotfiles

This repository includes configuration and scripts for installation. Automates configuring various tools to my liking.

It includes configuration for the following:

- Firefox
- Neovim
- Hyprland
- Bash
- git
- GTK
- MIME file associations

The setup scripts were written with Arch Linux in mind, but they have been verified on Fedora, Ubuntu, and Android (with Termux). Note that these settings will override the existing ones on the system, including the bashrc.

## Setup

In a Linux terminal:

`git clone https://github.com/pgattic/dotfiles ~/.dotfiles/ && cd ~/.dotfiles && ./setup-all.sh`

In addition, I have a list of packages that I usually want to have installed as a base on every Arch Linux system, found in `./packages-arch`. They can be installed using the command `sudo pacman -S $(cat packages-arch)`.

After that, a simple `git commit` and `git pull` synchronize the dotfiles of my machine with these ones.

