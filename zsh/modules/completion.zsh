#* -*- sh -*-
# 補完まわり（complist / compinit / 色 / zstyle）
zmodload zsh/complist  # menuselect キーマップに必要
autoload -Uz compinit && compinit

source ~/.zsh/ls_colors.zsh
# 色設定
autoload -Uz colors && colors
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*' verbose yes
zstyle ':completion:*:default' menu select=2

zstyle ':completion:*:descriptions' format $YELLOW'completing %B%d%b'$DEFAULT
zstyle ':completion:*:options' description 'yes'
# グループ名に空文字列を指定すると，マッチ対象のタグ名がグループ名に使われる。
# したがって，すべての マッチ種別を別々に表示させたいなら以下のようにする
zstyle ':completion:*' group-name ''
