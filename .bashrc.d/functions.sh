
cl() { builtin cd "$@" && ls -F; }

can() { canon "$@" -v | canonmk -n | less --wordwrap -R; }

