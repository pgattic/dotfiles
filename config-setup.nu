#/usr/bin/nu

# `dir`: name of directory to symlink to `~/.config/`
# `deps` (optional): system programs that the config depends on
let configs = [
  { dir: "nvim", deps: ["nvim", "rg"]},
  # { dir: "waybar", deps: ["waybar", "pavucontrol", "python3"] },
  { dir: "fuzzel", deps: ["fuzzel"] },
  # { dir: "hypr", deps: ["hyprland"] },
  { dir: "zed", deps: ["zeditor"] },
  # { dir: "ghostty", deps: ["ghostty"] }, # Also needs `ttf-jetbrains-mono-nerd` package
  { dir: "kitty", deps: ["kitty", "nu"] }, # Also needs `ttf-jetbrains-mono-nerd` package
  { dir: "nushell", deps: ["nu", "pokeget"] },
  { dir: "niri", deps: ["niri", "ironbar", "thunar", "fuzzel", "swaync", "swaybg", "xwayland-satellite", "wpctl", "brightnessctl"] },
  { dir: "ironbar", deps: ["ironbar", "playerctl"] },
]

let repo_dir = ($env.PWD)
let conf_home = ($env.HOME | path join ".config")

let missing_progs = (
  $configs
  | each {|conf|
    print $"Setting up (ansi blue)($conf.dir)(ansi reset)..."

    # Find missing commands
    let $missing = ($conf.deps? | default []) | where {|p| (which $p | is-empty) }
    for prog in $missing {
      print $"    (ansi yellow_bold)Warning:(ansi reset) Command (ansi blue)($prog)(ansi reset) not found on this system."
    }

    # Symlinking operations
    let source = ($repo_dir | path join ".config" | path join $conf.dir)
    let target = ($conf_home | path join $conf.dir)

    if ($target | path exists) { rm -rf $target }
    ln -s $source $target

    # Return missing commands
    $missing
  }
  | flatten
  | uniq
)

# MacOS stuff
if (sys host).name == Darwin {
  if ($nu.default-config-dir | path exists) {
    rm -rf $nu.default-config-dir
  }
  ln -s ($repo_dir | path join ".config/nushell") $nu.default-config-dir
}

print $"(ansi green)Done(ansi reset)." 
if (not ($missing_progs | is-empty)) {
  print $"Missing programs: ($missing_progs | str join ' ')"
}

