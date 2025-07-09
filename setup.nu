#!/usr/bin/nu

# `dir`: name of directory
# `deps` (optional): system programs that the config depends on
# `target` (optional): location to symlink to (defaults to `$HOME/.config/$dir`)
let configs = [
  { dir: "nvim", deps: ["nvim", "rg"]},

  ...(
    # Platform-specific programs
    if $nu.os-info.name == "linux" {
      [
        { dir: "gtk-3.0" },
        { dir: "wallpaper" },
        # { dir: "ghostty", deps: ["ghostty"] },
        { dir: "kitty", deps: ["kitty", "nu"] }, # Also needs `ttf-jetbrains-mono-nerd` package
        # { dir: "waybar", deps: ["waybar", "pavucontrol", "python3", "nmtui"] },
        { dir: "fuzzel", deps: ["fuzzel"] },
        # { dir: "hypr", deps: ["hyprland", "waybar", "fuzzel", "swaync", "swaybg", "brightnessctl", "blueman", "nmtui"] },
        { dir: "zed", deps: ["zeditor"] },
        { dir: "niri", deps: ["niri", "ironbar", "thunar", "fuzzel", "swaync", "swaybg", "xwayland-satellite", "wpctl", "brightnessctl", "nmtui"] },
        { dir: "ironbar", deps: ["ironbar", "playerctl"] },
        { dir: "nushell", deps: ["nu", "nvim"] },
        { dir: ".gitconfig", target: ($nu.home-path | path join ".gitconfig")}
        { dir: ".bashrc", target: ($nu.home-path | path join ".bashrc")}
        # { dir: "helix", deps: ["helix", "rust-analyzer"] },
      ]
    } else if $nu.os-info.name == "android" {
      [
        { dir: "nushell", deps: ["nu", "nvim"] },
        { dir: "termux", target: ($nu.home-path | path join ".termux") },
      ]
    } else if $nu.os-info.name == "macos" {
      [
        # { dir: "ghostty", deps: ["ghostty"] },
        { dir: "kitty", deps: ["kitty", "nu"] }, # Also needs `ttf-jetbrains-mono-nerd` package
        { dir: "nushell", deps: ["nu", "nvim"], target: ($nu.home-path | path join "Library/Application Support/nushell") }, # Nushell config dir is different on MacOS
      ]
    } else { [] }
  )
]

let dotfiles_path = $env.FILE_PWD

# Symlink a directory from `$dotfiles_path/config`, reporting missing dependencies
def link_and_check [
  dirname: string, # Name of directory from `$dotfiles_path/config` to work with
  --deps: list<string>, # Programs that the config depends on
  --target: string # System target path to symlink $dir to
] {
  # Find missing commands
  let $missing = ($deps | default []) | where {|p| (which $p | is-empty) }
  for prog in $missing {
    print $"(ansi yellow_bold)Warning:(ansi reset) Command (ansi blue)($prog)(ansi reset) not found on this system \(required by (ansi light_blue)($dirname)(ansi reset)\)"
  }

  # Symlinking operations
  let source = ($dotfiles_path | path join "config" | path join $dirname)
  let target_dir = ($target | default ($env.HOME | path join ".config" | path join $dirname))

  print $"Linking (ansi light_cyan)($source)(ansi reset) -> (ansi light_purple)($target_dir)(ansi reset)"
  if ($target_dir | path exists) { rm -rf $target_dir }
  ln -s $source $target_dir

  # Return missing commands
  $missing | wrap "missing"
}

# Link and check all configs, as defined in `$configs`
def link_check_all [] {
  let missing_progs = (
    $configs
    | each {|conf| (link_and_check $conf.dir --deps $conf.deps? --target $conf.target?).missing }
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
print $"(ansi light_green)Commands(ansi reset):"
print $"  (ansi light_cyan)link_and_check(ansi reset) {flags} <dirname>"
print $"  (ansi light_cyan)link_check_all(ansi reset)"
print ""
print $"(ansi light_green)Variables(ansi reset):"
print $"  (ansi purple)$configs(ansi reset) \(($configs | length) item\(s\)\): ($configs)"
print $"  (ansi purple)$dotfiles_path(ansi reset): ($dotfiles_path)"
print ""

