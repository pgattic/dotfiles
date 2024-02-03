#export PS1="\\w:\$(git branch 2>/dev/null | grep '^*' | colrm 1 2)\$ "
#export PS1=' \u:\w\$ '
#PS1='\[\e[97m\]\[\e[36;107m\]  \[\e[97;42;1m\] pgattic \[\e[0;32;44m\] \[\e[97m\]\w \[\e[0;34m\] \[\e[0m\]\$ '

#PROMPT_COMMAND='GIT_BRANCH=$(git branch 2>/dev/null | grep '"'"'*'"'"' | colrm 1 2); 
#if [ ${#GIT_BRANCH} -gt 0 ]
#then
#  GIT_BRANCH=" 󰘬 $GIT_BRANCH ";
#fi'
#PS1='\[\e[97m\]\[\e[36;107m\]  \[\e[97;42;1m\] \u \[\e[0;32;44m\] \[\e[97m\]\w \[\e[0;34m\]\[\e[94;40m\]${GIT_BRANCH}\[\e[0m\] \$ '


PROMPT_COMMAND='GIT_BRANCH=$(git branch 2>/dev/null | grep '"'"'*'"'"' | colrm 1 2); 
if [ ${#GIT_BRANCH} -gt 0 ]
then
  GIT_BRANCH=" 󰘬 $GIT_BRANCH";
fi'
PS1='\[\e[97m\]\[\e[36;107m\]  \[\e[97;42;1m\] \u \[\e[0;32;44m\] \[\e[97m\]\w \[\e[0;34m\]\[\e[94m\]${GIT_BRANCH}\[\e[0m\]\n \$ '

