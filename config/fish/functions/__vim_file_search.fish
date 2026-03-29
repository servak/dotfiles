function __vim_file_search
    set -l files

    if git rev-parse --is-inside-work-tree >/dev/null 2>/dev/null
        set files (git ls-files | fzf -m --query (commandline))
    else
        set files (find . -type f | fzf -m --query (commandline))
    end

    if test (count $files) -gt 0
        set -l escaped (string escape -- $files)
        commandline --replace "v "(string join ' ' $escaped)
        commandline -f execute
        return 0
    end

    commandline -f repaint
end
