#* -*- sh -*-
# Alias 設定
alias du='du -h'
alias df='df -h'
alias su='su -l'
# lsエイリアスはプラットフォーム固有設定で定義
alias vi='vim'
alias em='emacsclient -c'
alias v='vim'
alias ur='cd "$(git rev-parse --show-toplevel)"'
alias u='cd ..'
alias uu='cd ../..'
alias uuu='cd ../../..'
alias uuuu='cd ../../../..'
alias be='bundle exec'
alias less='less -gj10R'
alias reload='exec /bin/zsh -l'
alias kn='kubectl config set-context --current --namespace "$(kubectl get ns -o name | fzf -d/ --with-nth=2 | cut -d/ -f2)"'

# git / global pipe 系の短縮は zsh-abbr で定義（~/.zsh/modules/abbreviations.zsh）
