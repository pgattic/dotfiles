# https://www.nushell.sh/book/configuration.html
# This file is loaded after env.nu and before login.nu

$env.config.buffer_editor = "nvim"
$env.config.show_banner = false
$env.path ++= ["/home/pgattic/bin"]

# Startup commands
pokeget 389 --hide-name # Torterra
uptime -p # uptime


