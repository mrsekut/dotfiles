
# ########################################
# Paths
# ########################################

# source $ZSH/oh-my-zsh.sh
export PATH="/usr/local/opt/libxml2/bin:$PATH"
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
eval $(thefuck --alias)
export EDITOR=vim

# ########################################
# alias
# ########################################

alias cdd='cd $(ghq list --full-path | fzf) && code .'
alias cdg='cd $(ghq list --full-path | fzf)'
alias codeg='ghq list --full-path | fzf | xargs code'

alias sed=gsed

