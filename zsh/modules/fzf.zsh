#* -*- sh -*-
# FZF 設定。検索ウィジェット関数は autoload（実体は ~/.zsh/functions/）。
# ウィジェット登録・キーバインドは keybinds.zsh 側。

# 色は iTerm2 / WezTerm の配色（背景 #2b2b2b、アクセント #80ebdf）に合わせる
export FZF_DEFAULT_OPTS="--height=60% --layout=reverse --border=rounded --margin=0,1 --info=inline-right --prompt='❯ ' --pointer='▌' --marker='┃' --separator='─' --scrollbar='│' --color=fg:#d0d0d0,bg:-1,hl:#80ebdf,fg+:#ffffff,bg+:#3a3a3a,hl+:#80ebdf --color=border:#4a4a4a,label:#80ebdf,prompt:#80ebdf,pointer:#80ebdf,marker:#f0e68c,info:#7a7a7a,spinner:#80ebdf,header:#7a7a7a"
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
    filter-cmdsearch-history filter-src filter-worktree vim-file-search filter-multi-ssh
