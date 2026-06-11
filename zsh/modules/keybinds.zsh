#* -*- sh -*-
# キーバインド
# 注意: bindkey -e（キーマップ確定）と zsh-abbr は zshrc 側で本モジュールより
# 前に実行済み。ウィジェットの関数は functions.zsh / fzf.zsh で定義済み。

bindkey "^[[1~" beginning-of-line # Home gets to line head
bindkey "^[[4~" end-of-line # End gets to line end
bindkey "^[[3~" delete-char # Del

# historical backward/forward search with linehead string binded to ^P/^N
#
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end
bindkey "^?"  backward-delete-char
bindkey "^H"  backward-delete-char
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# reverse menu completion binded to Shift-Tab
#
bindkey "\e[Z" reverse-menu-complete

# ウィジェット登録とキーバインド
zle -N do_enter
bindkey '^j' do_enter
zle -N filter-cmdsearch
bindkey '^ ' filter-cmdsearch
zle -N filter-cmdsearch-history
bindkey '^r' filter-cmdsearch-history
zle -N filter-src
bindkey "^[g" filter-src
zle -N vim-file-search
bindkey '^[v' vim-file-search
zle -N filter-multi-ssh
bindkey "^[s" filter-multi-ssh
zle -N cdup
bindkey '^[u' cdup
