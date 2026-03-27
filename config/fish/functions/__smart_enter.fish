function __smart_enter
    if test -n (commandline)
        commandline -f execute
        return 0
    end

    echo
    description
    echo
    echo
    commandline -f repaint
end
