function __smart_enter
    if test -n (commandline)
        commandline -f execute
        return 0
    end

    # ll と同じ表示。コマンド置換の中は端末ではないので、色とアイコンは always で明示する
    set -l ls_result (eza -lF --sort=modified --git --icons=always --color=always --time-style='+%Y-%m-%d %H:%M' . </dev/null)
    set -l ls_lines (count $ls_result)

    echo
    if test $ls_lines -gt 30
        printf '%s\n' $ls_result[1..15]
        echo '...'
        printf '%s\n' $ls_result[(math "$ls_lines - 14")..$ls_lines]
        echo "$ls_lines files exist."
    else
        printf '%s\n' $ls_result
    end

    echo
    echo
    commandline -f repaint
end
