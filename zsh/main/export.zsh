# License : MIT
# http://mollifier.mit-license.org/

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

# npm
export PATH=$PATH:`npm bin -g`

# purescript
export PATH=/usr/local/Cellar/purescript/0.14.1/bin:$PATH

# stack
export PATH=$PATH:/Users/mrsekut/.local/bin

# Androidデバッグのsystraceの為
# ref https://github.com/microsoft/vscode-cordova/issues/586#issuecomment-543072202
export ANDROID_HOME=/Users/$USER/Library/Android/sdk
export ANDROID_SDK_ROOT=$ANDROID_HOME
export PATH="$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"

# php
export PATH=/usr/local/Cellar/php@7.4/7.4.16/bin:$PATH

# symfony
export PATH=$HOME/.symfony/bin:$PATH

# rbenv
[[ -d ~/.rbenv  ]] && \
  export PATH=${HOME}/.rbenv/bin:${PATH} && \
  eval "$(rbenv init -)"

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

