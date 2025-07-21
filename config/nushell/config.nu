# https://www.nushell.sh/book/configuration.html
# This file is loaded after env.nu and before login.nu

$env.config = {
  buffer_editor: "nvim",
  show_banner: false,
  filesize: {
    unit: "binary",
    # unit: "B",
    # show_unit: false,
  }
  history: {
    file_format: 'sqlite',
    isolation: true, # Don't mix history from concurrent sessions
  }
  # table: {
  #   index_mode: "auto",
  # }
}

# Won't hurt if these paths don't exist on current system
$env.path ++= [
  $"($env.home)/bin", # User binaries
  $"($env.home)/.cargo/bin", # Rust binaries
  $"($env.home)/.ghcup/bin" # Haskell binaries
]

# MacOS stuff
if $nu.os-info.name == macos {
  $env.path ++= [
    "/usr/local/bin" # Homebrew packages
  ]
}

# Print out the names of all files, followed by their content. Useful for LLM usage
def llm-ify [] {
  ls **/* | where type == file | reduce -f "" {|f, acc|
    try {
      let content = open $f.name
      $acc + $"=== ($f.name) ===\n" + ($content | into string) + "\n\n"
    } catch {
      $acc  # Skip unreadable (likely binary) files
    }
  }
}

# Startup commands
open --raw ($nu.default-config-dir | path join "torterra.txt") | print
$"Uptime: (ansi light_green_bold)((sys host).uptime)(ansi reset)"

