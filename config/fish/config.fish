set -g fish_greeting

set -gx EDITOR vim
set -gx PYTHONDONTWRITEBYTECODE 1
set -gx FZF_DEFAULT_OPTS '--height 40% --reverse --border'
set -gx WORDCHARS '*?_-.[]~&;!#$%^(){}<>'

umask 022

fish_add_path -g ~/.zsh/bin

switch (uname)
case Darwin
    if test -x /opt/homebrew/bin/brew
        /opt/homebrew/bin/brew shellenv fish | source
    end

    fish_add_path -g ~/.zsh/bin/Darwin

    alias tac='tail -r'
    alias sha256sum='gsha256sum'
    alias gls='gls --color'
    alias sed='gsed'
    alias ghp='gh pr create --web'
    alias ls='gls -F'
    alias ll='ls -ltrF'
    alias la='ll -a'
    alias tree='eza --tree --color=auto'
    alias exa='eza --group-directories-first --color=auto'
case Linux
    fish_add_path -g ~/.zsh/bin/Linux/(uname -m)
end

if command -sq mise
    mise activate fish | source
end

if command -sq zoxide
    zoxide init fish | source
end

alias du='du -h'
alias df='df -h'
alias su='su -l'
alias vi='vim'
alias em='emacsclient -c'
alias v='vim'
alias less='less -gj10R'

abbr --erase g >/dev/null 2>&1
abbr --add --position command g git
abbr --erase gs >/dev/null 2>&1
abbr --add --position command gs 'git status'
abbr --erase gd >/dev/null 2>&1
abbr --add --position command gd 'git diff'
abbr --erase gdc >/dev/null 2>&1
abbr --add --position command gdc 'git diff --cached'
abbr --erase gb >/dev/null 2>&1
abbr --add --position command gb 'git branch'
abbr --erase gba >/dev/null 2>&1
abbr --add --position command gba 'git branch -a'
abbr --erase gbr >/dev/null 2>&1
abbr --add --position command gbr 'git branch -r'
abbr --erase gg >/dev/null 2>&1
abbr --add --position command gg 'git graph'
abbr --erase gga >/dev/null 2>&1
abbr --add --position command gga 'git graphall'
abbr --erase grv >/dev/null 2>&1
abbr --add --position command grv 'git remote -v'
abbr --erase gf >/dev/null 2>&1
abbr --add --position command gf 'git fetch -p'
abbr --erase gp >/dev/null 2>&1
abbr --add --position command gp 'git pull --ff-only'
abbr --erase k >/dev/null 2>&1
abbr --add --position command k kubectl

abbr --erase T >/dev/null 2>&1
abbr --add --global T '| tail'
abbr --erase H >/dev/null 2>&1
abbr --add --global H '| head'
abbr --erase L >/dev/null 2>&1
abbr --add --global L '| less'
abbr --erase G >/dev/null 2>&1
abbr --add --global G '| grep'
abbr --erase W >/dev/null 2>&1
abbr --add --global W '| wc -l'
abbr --erase V >/dev/null 2>&1
abbr --add --global V '| vim -R -'
abbr --erase C >/dev/null 2>&1
abbr --add --global C '| pbcopy'

if command -sq starship
    starship init fish | source
end

if test -f ~/.config/fish/local.fish
    source ~/.config/fish/local.fish
end
