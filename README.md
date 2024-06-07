# .dotfiles

Acts as a mini "Home" directory, and automates installing my preset settings for various tools.

## Setup

In a Linux terminal:

`git clone https://github.com/pgattic/dotfiles ~/.dotfiles/ && cd ~/.dotfiles && ./setup.sh`

In addition, I have a list of packages that I usually want to have installed as a base on every Arch Linux system, found in `./packages-arch`. They can be installed using the command `sudo pacman -S $(cat packages-arch)`.

After that, a simple `git commit` and `git pull` synchronize the dotfiles of my machine with these ones.

