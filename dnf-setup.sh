#!/bin/sh

echo "Customizing dnf Packages..."

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

sudo dnf copr enable atim/lazygit -y

sudo dnf update -y
sudo dnf install ripgrep neovim gcc gnome-tweaks libgda libgda-sqlite code lazygit gnome-extensions-app -y

