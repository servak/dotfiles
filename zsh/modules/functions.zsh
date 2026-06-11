#* -*- sh -*-
# 汎用関数（ウィジェット登録・キーバインドは keybinds.zsh 側）

function mkcd() {
    if [ -d $1 ]; then
        cd $1
    else
        mkdir -p $1
        cd $1
    fi
}

function description() {
    local ls_result="$(ll)"
    local ls_lines=$(echo "$ls_result" | wc -l | tr -d ' ')

    if [ $ls_lines -gt 30 ]; then
        echo "$ls_result" | head -n 15
        echo '...'
        echo "$ls_result" | tail -n 15
        echo "$ls_lines files exist."
    else
        echo "$ls_result"
    fi

    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
        local git_status=""
        git_status=$(git status -s)
        if [ "$git_status" != "" ]; then
            echo
            echo -e "\e[0;33m--- git status ---\e[0m"
            echo "$git_status"
        fi
    fi
}

function do_enter() {
    if [ -n "$BUFFER" ]; then
        zle accept-line
        return 0
    fi
    echo
    description
    # PROMPTの行数分だけ空行を挿入
    echo
    echo
    zle reset-prompt
}

function multi-ssh-cmd() {
    local multi_filename=$1
    local -a ssh_servers
    ssh_servers=($(cat $multi_filename | tr '\n' ' '))
    if [ -z "$ssh_servers[1]" ]; then
        return 0
    fi

    tmux new-window -n $multi_filename
    tmux send-keys "ssh $ssh_servers[1]" C-m
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
        tmux rename-window $multi_filename
    fi
    return 0
}

function cdup() {
  cd ..
  zle push-line-or-edit
  zle accept-line
}

function color256(){
    for code in {000..255}
    do
        print -nP -- "%F{$code}$code %f"
        [ $((${code} % 16)) -eq 15 ] && echo
    done
}
