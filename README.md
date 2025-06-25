
# .dotfiles

This repository includes config files and scripts for their installation.

## Setup

1. Ensure [Nushell](https://www.nushell.sh/) has been installed
2. `git clone https://github.com/pgattic/dotfiles ~/.dotfiles/ && cd ~/.dotfiles && nu config-setup.nu`

In addition, I have a list of packages that I usually want to have installed as a base on every Arch Linux system, found in `./packages-arch`. They can be installed using the command `sudo pacman -S $(./packages-arch)`.

After that, a simple `git commit` and `git pull` synchronizes the dotfiles of my machine with these ones.

