
echo "Setting up Sway..."

echo "Installing Sway-related packages..."

sudo dnf install waybar brightnessctl pulseaudio-utils fuzzel -y

echo "Done!"

echo "Linking configs..."

rm -rf ~/.config/sway
ln -s ~/.dotfiles/.config/sway ~/.config/

rm -rf ~/.config/waybar
ln -s ~/.dotfiles/.config/waybar ~/.config/

rm -rf ~/.config/foot
ln -s ~/.dotfiles/.config/foot ~/.config/

rm -rf ~/.config/fuzzel
ln -s ~/.dotfiles/.config/fuzzel ~/.config/

echo "Done!"
echo "Press Win+Shift+C to restart Sway"

