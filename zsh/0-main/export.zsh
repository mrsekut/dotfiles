
# ########################################
# alias
# ########################################

alias cdd='cd $(ghq list --full-path | fzf) && code .'
alias cdg='cd $(ghq list --full-path | fzf)'
alias codeg='ghq list --full-path | fzf | xargs code'

alias sed=gsed

