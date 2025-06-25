#/usr/bin/nu

let repo_dir = ($env.PWD)
let conf_home = ($env.HOME | path join ".config")

# See `configs.nuon` to customize setup
let configs = open configs.nuon

for conf in $configs {
  let pkg_name = ($conf.package? | default $conf.program)

  if (which $conf.program | is-empty) {
    print (ansi yellow_bold) + "WARNING:" + (ansi reset) + $" ($conf.program) not found. Try installing ($conf.package)"
  }

  let source = ($repo_dir | path join ".config" | path join $conf.dir)
  let target = ($conf_home | path join $conf.dir)

  if ($target | path exists) {
    rm -rf $target
  }

  ln -s $source $target
}

