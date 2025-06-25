#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Get git branch name
PROMPT_COMMAND='GIT_BRANCH=$(git branch 2>/dev/null | grep '"'"'*'"'"' | colrm 1 2);
if [ ${#GIT_BRANCH} -gt 0 ]
then
  GIT_BRANCH=" $branch_char $GIT_BRANCH";
fi'

ppid_comm=$(cat /proc/$PPID/comm)

if [ "$ppid_comm" = login ]; then
  # Running in a TTY; only use ASCII extended chars

  branch_char="╜"
  PS1='\[\e[34m\]▒\[\e[97;44m\]\u\[\e[0;34m\]▒\[\e[97m\] \w\[\e[94m\]${GIT_BRANCH}\[\e[0m\]\n \$ '

else
  # Running in a terminal emulator; go crazy

  branch_char="󰘬"
  PS1='\[\e[97m\]\[\e[36;107m\]  \[\e[97;44;1m\] \u \[\e[0;34;100m\] \[\e[97m\]\w \[\e[0;90m\]\[\e[94m\]${GIT_BRANCH}\[\e[0m\]\n \$ '

  # Idk lol
  alias vi="neovide . &"
fi

# Vim motions
set -o vi

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias tree='tree -C'

# Cargo bin path, user bin path
PATH=$PATH:$HOME/.cargo/bin:$HOME/.local/bin

# functions

canl() {
  if [ -z "$1" ]; then
    echo "Usage: canl [REFERENCE]"
    return 1
  fi
  
  canon "$1" -v | marks -n | less -R --wordwrap
}

open() {
  if [ -z "$1" ]; then
    echo "Usage: open [REFERENCE]"
    return 1
  fi

  xdg-open $1 > /dev/null 2>&1 &
}


