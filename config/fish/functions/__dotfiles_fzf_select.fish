function __dotfiles_fzf_select --argument query
    set -l fzf_cmd (__dotfiles_fzf_command)
    $fzf_cmd --query "$query"
end
