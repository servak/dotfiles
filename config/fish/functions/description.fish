function description
    set -l ls_result (ll)
    set -l ls_lines (count $ls_result)

    if test $ls_lines -gt 30
        printf '%s\n' $ls_result[1..15]
        echo '...'
        printf '%s\n' $ls_result[(math "$ls_lines - 14")..$ls_lines]
        echo "$ls_lines files exist."
    else
        printf '%s\n' $ls_result
    end

    if git rev-parse --is-inside-work-tree >/dev/null 2>/dev/null
        set -l git_status (git status -s)
        if test -n "$git_status"
            echo
            printf '\e[0;33m--- git status ---\e[0m\n'
            printf '%s\n' $git_status
        end
    end
end
