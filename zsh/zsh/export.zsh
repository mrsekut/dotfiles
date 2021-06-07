# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="ys"
source $ZSH/oh-my-zsh.sh



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
