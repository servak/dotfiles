function __worktree_cd
    set -l lines (git-worktrees)
    if test -z "$lines"
        echo "git のリポジトリではありません" >&2
        commandline -f repaint
        return 1
    end

    set -l selected (printf '%s\n' $lines | fzf \
        --ansi \
        --delimiter \t --with-nth 1,2 --accept-nth 3 \
        --query (commandline) \
        --border-label ' worktree ' \
        --preview 'ghq-preview {3}' \
        --preview-window 'right,55%,border-left,<90(down,50%,border-top)')
    if test -n "$selected"
        cd $selected
        commandline --replace ''
    end

    commandline -f repaint
end
