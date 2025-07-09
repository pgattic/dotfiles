
# .dotfiles

This repository includes config files and scripts for their installation.

## Setup

1. Ensure [Nushell](https://www.nushell.sh/) has been installed and is the current shell
2. Clone this repository and `cd` into it
3. `source setup.nu`
4. Either run `link_check_all` to set up all default programs, or use the `link_and_check` command to symlink only one program. See their `--help` menus for more info.

After that, a simple `git commit; git push` and `git pull` synchronizes the dotfiles of my machine with these ones.

For ease of installation, I also have a few collections of packages that I typically have in a Linux installation. `source packages.nu` for more information.

