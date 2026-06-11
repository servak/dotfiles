#* -*- sh -*-
# FZF 設定と、FZF を使う検索ウィジェット関数群
# （ウィジェット登録・キーバインドは keybinds.zsh 側）

export FZF_DEFAULT_OPTS='--height 40% --reverse --border'
FZF=fzf
FZF_OPTS=
if [ $TMUX ]; then
    FZF=fzf-tmux
    FZF_OPTS="-p"
fi

# search snippet + history
# http://blog.glidenote.com/blog/2014/06/26/snippets-peco-percol/
# 履歴を NUL 区切りで出力する（改行を含むコマンドを 1 レコードとして保持）。
# $history 連想配列を使うため zsh/parameter をロードしておく。
zmodload -i zsh/parameter
function _cmdsearch_history_records() {
    local key
    for key in ${(Onk)history}; do
        print -rN -- "${history[$key]}"
    done
}
function _cmdsearch_snippet_records() {
    local line
    grep -hv '^#' ~/.zsh/snippets* 2>/dev/null | while IFS= read -r line; do
        print -rN -- "$line"
    done
}

function filter-cmdsearch() {
    local selected
    selected=$({ _cmdsearch_snippet_records; _cmdsearch_history_records; } \
        | $FZF $FZF_OPTS --read0 --query "$LBUFFER")
    if [ -n "$selected" ]; then
        BUFFER=$selected
        CURSOR=$#BUFFER
    fi
    zle clear-screen
}

function filter-cmdsearch-history() {
    local selected
    selected=$({ _cmdsearch_history_records; _cmdsearch_snippet_records; } \
        | $FZF $FZF_OPTS --read0 --query "$LBUFFER")
    if [ -n "$selected" ]; then
        BUFFER=$selected
        CURSOR=$#BUFFER
    fi
    zle clear-screen
}


function filter-src () {
    local selected_dir=$(ghq list --full-path | $FZF $FZF_OPTS --query "$LBUFFER")
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}

function vim-file-search() {
    if [[ $(command git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]]; then
        files=$((git ls-files) | $FZF $FZF_OPTS -m | tr '\n' ' ')
    else
        files=$((find . -type f) | $FZF $FZF_OPTS -m | tr '\n' ' ')
    fi

    if [ -n "$files" ]; then
        BUFFER="v $files"
        zle accept-line
    fi
    zle clear-screen
}

function filter-multi-ssh() {
    local -a ssh_servers
    ssh_servers=($((cat ~/.ssh/known_hosts | sed -e 's/[, ].*$//' | sort -u) | $FZF $FZF_OPTS -m | tr '\n' ' '))
    if [ -z "$ssh_servers[1]" ]; then
        return 0
    fi

    BUFFER="ssh $ssh_servers[1]"
    zle accept-line
    zle clear-screen
    shift ssh_servers

    for host in $ssh_servers
    do
        tmux split-window -h "ssh $host"
        tmux select-layout tiled > /dev/null
    done

    local len_servers=$#ssh_servers
    if [ $len_servers -ne 0 ]; then
        tmux select-pane -t 0
        tmux set-window-option synchronize-panes on
        tmux rename-window "ssh-multi"
    fi
    return 0
}
