function __cmdsearch
    set -l selected (grep -hv '^#' ~/.zsh/snippets* 2>/dev/null | awk 'NF && !seen[$0]++' | __dotfiles_fzf_select (commandline))

    if test -n "$selected"
        commandline --replace "$selected"
    end

    commandline -f repaint
end
