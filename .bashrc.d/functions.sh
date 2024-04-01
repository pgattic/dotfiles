
cl() { builtin cd "$@" && ls -F; }

can() { canon "$@" -v | marks -n; }
canl() { can "$@" | less --wordwrap -R; }

