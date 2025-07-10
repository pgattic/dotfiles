
# .dotfiles

This repository includes config files and scripts for their installation.

## Usage

1. Ensure [Nushell](https://www.nushell.sh/) has been installed and is the current shell
2. Clone this repository and `cd` into it
3. `source setup.nu`
4. Either run `link_check_all` to set up all default configs, or use the `link_and_check` command to symlink only one item. See their respective `--help` menus for more information.

The provided commands perform a symlink operation, which means that when the configs are edited in their destination location, the changes apply to the repository as well. This allows changes to be synchronized through Git with little effort.

For ease of installation, I also have a few collections of packages that I typically have in a Linux installation. `source packages.nu` for more information.

