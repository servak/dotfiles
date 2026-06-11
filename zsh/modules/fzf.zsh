#* -*- sh -*-
# FZF 設定。検索ウィジェット関数は autoload（実体は ~/.zsh/functions/）。
# ウィジェット登録・キーバインドは keybinds.zsh 側。

export FZF_DEFAULT_OPTS='--height 40% --reverse --border'
FZF=fzf
FZF_OPTS=
if [ $TMUX ]; then
    FZF=fzf-tmux
    FZF_OPTS="-p"
fi

# search snippet + history
# http://blog.glidenote.com/blog/2014/06/26/snippets-peco-percol/
# _cmdsearch_history_records が $history 連想配列を使うため zsh/parameter をロード。
zmodload -i zsh/parameter
autoload -Uz _cmdsearch_history_records _cmdsearch_snippet_records \
    filter-cmdsearch filter-cmdsearch-history filter-src vim-file-search filter-multi-ssh
