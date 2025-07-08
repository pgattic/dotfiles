
# .dotfiles

This repository includes config files and scripts for their installation.

## Setup

1. Ensure [Nushell](https://www.nushell.sh/) has been installed and is the current shell
2. Clone this repository and `cd` into it
3. `source config-setup.nu`
4. Either run `link_check_all` to set up all default programs, or use the `link_and_check` command to symlink only one program. See their `--help` menus for more info.

In addition, I have a list of packages that I usually want to have installed as a base on every Arch Linux system, found in `./packages-arch`. They can be installed using the command `sudo pacman -S $(./packages-arch)`.

After that, a simple `git commit` and `git pull` synchronizes the dotfiles of my machine with these ones.

