
########################################
# oh-my-zsh
export ZSH="/Users/mrsekut/.oh-my-zsh"
ZSH_THEME="ys"
source $ZSH/oh-my-zsh.sh

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


# ########################################
# ZLE
# ########################################

# ctrl-rでhistoryをfzfを使って表示
function select-history() {
  BUFFER=$(history -n -r 1 | fzf --no-sort +m --query "$LBUFFER" --prompt="History > ")
  CURSOR=$#BUFFER
}
zle -N select-history
bindkey '^r' select-history

