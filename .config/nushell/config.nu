# https://www.nushell.sh/book/configuration.html
# This file is loaded after env.nu and before login.nu

$env.config.buffer_editor = "nvim"
$env.config.show_banner = false

# Won't hurt if these paths don't exist on current system
$env.path ++= [
  $"($env.home)/bin", # User binaries
  $"($env.home)/.cargo/bin", # Rust binaries
  $"($env.home)/.ghcup/bin" # Haskell binaries
]

# Startup commands
if not (which pokeget | is-empty) {
  pokeget 389 --hide-name # Torterra
}
$"Uptime: (ansi light_green_bold)(uptime -p | str substring 3..)(ansi reset)"

