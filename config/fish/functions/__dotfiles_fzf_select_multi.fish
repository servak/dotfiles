function __dotfiles_fzf_select_multi --argument query
    set -l fzf_cmd (__dotfiles_fzf_command)
    $fzf_cmd -m --query "$query"
end
