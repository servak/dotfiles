# History configuration
HISTFILE=${HOME}/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt hist_ignore_all_dups # 直前のコマンドと同じ場合、履歴に追加しない
setopt share_history # share command history data
setopt extended_history # 履歴に日付も入れる