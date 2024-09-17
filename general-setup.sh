
#!/bin/bash

color_off='\033[0m'
red='\033[0;31m'
green='\033[0;32m'
yellow_b='\033[1;33m'
this_dir=$(dirname $0)

### Bash ###
echo "Setting up bash..."

rm "$HOME/.bashrc"
ln -s "$this_dir/.bashrc" "$HOME/"

printf "${green}bash setup complete.${color_off}\n"


### Git ###
echo "Setting up git..."

./check-installed git

# Remove current copies of the dotfiles
# (Note to future self: both of these commands work whether there is a pre-existing link, or a pre-existing directory/file)
unlink "$HOME/.gitconfig"

# ln -s means symbolic link, and it applies to both directories and files.
ln -s "$HOME/.dotfiles/.gitconfig" "$HOME/.gitconfig"

printf "${green}git setup complete.${color_off}\n"


### GTK ###
echo "Setting up gtk..."

rm -rf "$HOME/.config/gtk-3.0"
ln -s "$HOME/.dotfiles/.config/gtk-3.0" "$HOME/.config/"

printf "${green}gtk setup complete.${color_off}\n"


### MIME Types ###
echo "Setting up MIME type associations..."

rm "$HOME/.config/mimeapps.list"
ln -s "$HOME/.dotfiles/.config/mimeapps.list" "$HOME/.config"

printf "${green}Done.${color_off}\n"

unset color_off
unset red
unset green
unset yellow_b

