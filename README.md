# .dotfiles

Acts as a mini "Home" directory, and automates installing my preset settings for various tools.

It includes configuration files for the following tools:

- Firefox
- Neovim
- Sway (including foot, waybar, and wofi)
- Hyprland
- git

The setup scripts were written with Arch Linux in mind, but they have been verified on Fedora, Ubuntu, and Android (with Termux).

## Setup

In a Linux terminal:

`git clone https://github.com/pgattic/dotfiles ~/.dotfiles/ && cd ~/.dotfiles && ./setup.sh`

In addition, I have a list of packages that I usually want to have installed as a base on every Arch Linux system, found in `./packages-arch`. They can be installed using the command `sudo pacman -S $(cat packages-arch)`.

After that, a simple `git commit` and `git pull` synchronize the dotfiles of my machine with these ones.

