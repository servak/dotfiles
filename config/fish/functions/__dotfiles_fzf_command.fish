function __dotfiles_fzf_command
    if set -q TMUX
        printf '%s\n' fzf-tmux -p
    else
        printf '%s\n' fzf
    end
end
