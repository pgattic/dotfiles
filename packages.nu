#!/usr/bin/nu

let base_pkgs = [
  greetd-agreety # TUI greeter (installs greetd as a dep)

  # Desktop Environment
  niri # Compositor
  fuzzel # App Launcher
  swaybg # BG utility (hyprbg is a memory hog)
  swaync # Notifications daemon
  wl-clipboard # Clipboard
  brightnessctl # Display brightness
  kitty
  neovim
  zed # GUI edior
  git

  papirus-icon-theme # Icons
  ttf-jetbrains-mono-nerd # Nerd Font
  noto-fonts # Emojis and stuff
  noto-fonts-cjk # Eastern languages

  # Commandline Utils
  man-pages
  tree
  less
  ripgrep
  usbutils # Provides stuff like lsusb
  btop # Task management
  fastfetch # You already know ;)
  gdu # Totally goated disk usage analyzer

  # Basic Utils
  imv # Image Viewer
  mpv # Video Player

  nwg-look # GTK configurer
  pavucontrol # Audio mixer
    pipewire-pulse # Compat between Pipewire and PulseAudio
  thunar # File manager
    gvfs # Trashbin, USB devices
    # exfatprogs # exFAT Partition scheme
    # ntfs-3g # NT Filesystem Support
  xarchiver # Archiver tool
    7zip # 7-zip compat
  # guvcview # Camera program
  # zbar # QR Code/Barcode reader
  obsidian
  discord

  # Software development
  tinyxxd # Hex dump tool

  # Bluetooth packages
  # blueman
]

let aur_pkgs = [
  ironbar # Status Bar
  zen-browser-bin
  ttf-joypixels # Twitter Emojis
  # mcpelauncher-appimage # Minecraft launcher
  # onedrive-abraunegg # CLI OneDrive client
  # pinta # simple paint tool
]

let flutter_android_pkgs = [
  flutter # AUR - NOTE: paru won't update unless passed the -d flag (skip dependency checking)
  android-studio # AUR
  android-udev # Allows ADB in user mode
]

let dioxus_desktop_pkgs = [
  webkit2gtk-4.1
  xdotool
]

print "Temporarily added the following variables to your environment:"
print ""
print $"  (ansi purple)$base_pkgs(ansi reset) \(($base_pkgs | length) items\): ($base_pkgs)"
print $"  (ansi purple)$aur_pkgs(ansi reset) \(($aur_pkgs | length) items\): ($aur_pkgs)"
print ""
print $"Example usage: (ansi cyan)sudo (ansi green)pacman -Syu (ansi yellow)...(ansi purple)$base_pkgs"
print ""

