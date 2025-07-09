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

fi

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias tree='tree -C'

# Cargo bin path, user bin path
PATH=$PATH:$HOME/.cargo/bin:$HOME/bin

# POKEMON STUFF

# random_number=$((RANDOM % 3))
#
# case $random_number in
#   "0") # Torterra
#     pokemon_id=389
#     pokemon_name=Torterra
#     color_escape="\e[32m"
#     ps1_color="\[\e[32m\]"
#     ;;
#   "1") # Infernape
#     pokemon_id=392
#     pokemon_name=Infernape
#     color_escape="\e[31m"
#     ps1_color="\[\e[31m\]"
#     ;;
#   "2") # Empoleon
#     pokemon_id=395
#     pokemon_name=Empoleon
#     color_escape="\e[34m"
#     ps1_color="\[\e[34m\]"
#     ;;
# esac
#
# pokeget $pokemon_id --hide-name
#
# printf "\e[1m"
# printf "%b" "$color_escape"
# echo "$(uptime -p)"
# printf "\e[0m"
#
# PS1="${ps1_color}\u \w \$ \[\e[0m\]"
#
