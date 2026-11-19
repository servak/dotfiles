function __ghq_cd
    if not command -sq ghq
        return 1
    end

    set -l selected (ghq list | fzf \
        --query (commandline) \
        --border-label ' ghq ' \
        --preview 'ghq-preview {}' \
        --preview-window 'right,55%,border-left,<90(down,50%,border-top)')
    if test -n "$selected"
        cd (ghq root)/$selected
        commandline --replace ''
    end

    commandline -f repaint
end
