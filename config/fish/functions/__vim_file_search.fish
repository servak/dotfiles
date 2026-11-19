function __vim_file_search
    # git の中では管理下のファイルを出す
    set -l list
    if git rev-parse --is-inside-work-tree >/dev/null 2>/dev/null
        set list (git ls-files)
    else
        set list (find . -type f -not -path '*/.git/*' | sed 's|^\./||')
    end

    set -l files (printf '%s\n' $list | fzf -m \
        --query (commandline) \
        --border-label ' files ' \
        --preview 'bat --color=always --style=numbers --line-range=:300 {} 2>/dev/null || head -n 300 {}' \
        --preview-window 'right,60%,border-left,<90(down,50%,border-top)')

    if test (count $files) -gt 0
        set -l escaped (string escape -- $files)
        commandline --replace "v "(string join ' ' $escaped)
        commandline -f execute
        return 0
    end

    commandline -f repaint
end
