#* -*- sh -*-
# モジュール化されたzsh設定
# 基本設定読み込み
source ~/.zsh/modules/options.zsh
source ~/.zsh/modules/zinit.zsh

## Completion configuration
zmodload zsh/complist  # menuselect キーマップに必要
autoload -Uz compinit && compinit

bindkey "^[u" undo
bindkey "^[r" redo

export EDITOR=vim

# 履歴設定読み込み
source ~/.zsh/modules/history.zsh
# 色設定
autoload -Uz colors && colors
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Starshipの初期化はPATH設定後に移動

zstyle ':completion:*' verbose yes
zstyle ':completion:*:default' menu select=2

zstyle ':completion:*:descriptions' format $YELLOW'completing %B%d%b'$DEFAULT
zstyle ':completion:*:options' description 'yes'
# グループ名に空文字列を指定すると，マッチ対象のタグ名がグループ名に使われる。
# したがって，すべての マッチ種別を別々に表示させたいなら以下のようにする
zstyle ':completion:*' group-name ''

# キーバインド設定 {{{1
bindkey -e
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

# Alias設定 {{{1
alias du='du -h'
alias df='df -h'
alias su='su -l'
# lsエイリアスはプラットフォーム固有設定で定義
alias vi='vim'
alias em='emacsclient -c'
alias v='vim'
alias g='git'
alias ur='cd "$(git rev-parse --show-toplevel)"'
alias u='cd ..'
alias uu='cd ../..'
alias uuu='cd ../../..'
alias uuuu='cd ../../../..'
alias be='bundle exec'
alias less='less -gj10R'
alias gd='git diff'
alias gdc='git diff --cached'
alias gb='git branch'
alias gba='gb -a'
alias gbr='gb -r'
alias gg='git graph'
alias gga='git graphall'
alias grv='git remote -v'
alias gs='git status'
alias gf='git fetch -p'
alias gp='git pull --ff-only'
alias reload='exec /bin/zsh -l'
alias kn='kubectl config set-context --current --namespace "$(kubectl get ns -o name | fzf -d/ --with-nth=2 | cut -d/ -f2)"'

alias -g T='| tail'
alias -g H='| head'
alias -g L='| less'
alias -g G='| grep'
alias -g W='| wc -l'
alias -g V='| vim -R -'
alias -g C='| pbcopy'

# }}}1
[ -f ~/.zsh/zsh_`uname` ] && source ~/.zsh/zsh_`uname`
# 関数設定 {{{1
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
zle -N do_enter
bindkey '^j' do_enter

# FZF設定
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'
FZF=fzf
FZF_OPTS=
if [ $TMUX ]; then
    FZF=fzf-tmux
    FZF_OPTS="-p"
fi
# search snippet + history
# http://blog.glidenote.com/blog/2014/06/26/snippets-peco-percol/
function filter-cmdsearch() {
    BUFFER=$((grep -v "^#" ~/.zsh/snippets*; history -n 1 | tac) | $FZF $FZF_OPTS --query "$LBUFFER")
    zle clear-screen
}

function filter-cmdsearch-history() {
    BUFFER=$((history -n 1 | tac;grep -v "^#" ~/.zsh/snippets* ) | $FZF $FZF_OPTS --query "$LBUFFER")
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
zle -N cdup
bindkey '^[u' cdup

function color256(){
    for code in {000..255}
    do
        print -nP -- "%F{$code}$code %f"
        [ $((${code} % 16)) -eq 15 ] && echo
    done
}
# }}}1

[ -f ~/.zsh_local ] && source ~/.zsh_local

# プラットフォーム固有のPATH設定
PATH=~/.zsh/bin:$PATH

# Starship prompt initialization (PATH設定後)
if command -v starship > /dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

# vim:fdm=marker:fdc=3:fdl=0
