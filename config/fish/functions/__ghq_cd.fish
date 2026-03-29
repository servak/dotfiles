function __ghq_cd
    if not command -sq ghq
        return 1
    end

    set -l selected_dir (ghq list --full-path | fzf --query (commandline))
    if test -n "$selected_dir"
        cd "$selected_dir"
        commandline --replace ''
    end

    commandline -f repaint
end
