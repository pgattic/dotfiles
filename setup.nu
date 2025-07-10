#!/usr/bin/nu

# `name`: name of directory or file
# `deps` (optional): system programs that the config depends on
# `target` (optional): location to symlink to (defaults to `$HOME/.config/$item`)
let configs = [
  { name: "nvim", deps: ["nvim", "rg"]},

  ...(
    # Platform-specific programs
    if $nu.os-info.name == "linux" {
      [
        { name: "gtk-3.0" },
        { name: "wallpaper" },
        # { name: "ghostty", deps: ["ghostty"] },
        { name: "kitty", deps: ["kitty", "nu"] }, # Also needs `ttf-jetbrains-mono-nerd` package
        { name: "waybar", deps: ["waybar", "pavucontrol"] },
        { name: "fuzzel", deps: ["fuzzel"] },
        # { name: "hypr", deps: ["hyprland", "waybar", "fuzzel", "swaync", "swaybg", "brightnessctl", "blueman", "nmtui"] },
        { name: "zed", deps: ["zeditor"] },
        { name: "niri", deps: ["niri", "waybar", "thunar", "fuzzel", "swaync", "swaybg", "xwayland-satellite", "wpctl", "brightnessctl", "nmtui"] },
        { name: "ironbar", deps: ["ironbar", "playerctl"] },
        { name: "nushell", deps: ["nu", "nvim"] },
        { name: ".gitconfig", deps: ["git"], target: ($nu.home-path | path join ".gitconfig")}
        { name: ".bashrc", deps: ["bash", "tree"], target: ($nu.home-path | path join ".bashrc")}
        # { name: "helix", deps: ["helix", "rust-analyzer"] },
      ]
    } else if $nu.os-info.name == "android" {
      [
        { name: "nushell", deps: ["nu", "nvim"] },
        { name: "termux", target: ($nu.home-path | path join ".termux") },
      ]
    } else if $nu.os-info.name == "macos" {
      [
        # { name: "ghostty", deps: ["ghostty"] },
        { name: "kitty", deps: ["kitty", "nu"] }, # Also needs `ttf-jetbrains-mono-nerd` package
        { name: "nushell", deps: ["nu", "nvim"], target: ($nu.home-path | path join "Library/Application Support/nushell") }, # Nushell config dir is different on MacOS
      ]
    } else { [] }
  )
]

let dotfiles_path = $env.FILE_PWD

# Symlink a directory/file from `$dotfiles_path/config`, reporting missing dependencies
def link_and_check [
  item_name: string, # Name of directory/file from `$dotfiles_path/config` to work with
  --deps: list<string>, # Programs that the config depends on
  --target: string # System target path to symlink $item_name to
] {
  # Find missing commands
  let $missing = ($deps | default []) | where {|p| (which $p | is-empty) }
  for prog in $missing {
    print $"(ansi yellow_bold)Warning:(ansi reset) Command (ansi blue)($prog)(ansi reset) not found on this system \(required by (ansi blue)($item_name)(ansi reset)\)"
  }

  # Symlinking operations
  let source = ($dotfiles_path | path join "config" | path join $item_name)
  let target_abs = ($target | default ($env.HOME | path join ".config" | path join $item_name))

  print $"Linking (ansi cyan)($source)(ansi reset) -> (ansi purple)($target_abs)(ansi reset)"
  if ($target_abs | path exists) { rm -rf $target_abs }
  ln -s $source $target_abs

  # Return missing commands
  $missing | wrap "missing"
}

# Link and check all configs, as defined in `$configs`
def link_check_all [] {
  let missing_progs = (
    $configs
    | each {|conf| (link_and_check $conf.name --deps $conf.deps? --target $conf.target?).missing }
    | flatten
    | uniq
  )

  print $"(ansi green)Done(ansi reset)."
  if (not ($missing_progs | is-empty)) {
    print $"Missing programs: ($missing_progs | str join ' ')"
  }
}

print "Temporarily added the following to your environment:"
print ""
print $"(ansi green)Commands(ansi reset):"
print $"  (ansi cyan)link_and_check(ansi reset) {flags} <item_name>"
print $"  (ansi cyan)link_check_all(ansi reset)"
print ""
print $"(ansi green)Variables(ansi reset):"
print $"  (ansi purple)$configs(ansi reset) \(($configs | length) item\(s\)\): ($configs)"
print $"  (ansi purple)$dotfiles_path(ansi reset): ($dotfiles_path)"
print ""

