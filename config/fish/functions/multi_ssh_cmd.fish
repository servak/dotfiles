function multi_ssh_cmd --argument multi_filename
    if test -z "$multi_filename"
        return 1
    end

    if not test -f "$multi_filename"
        return 1
    end

    set -l ssh_servers (string split '\n' (string trim (cat "$multi_filename")))
    if test (count $ssh_servers) -eq 0
        return 0
    end

    tmux new-window -n "$multi_filename"
    tmux send-keys "ssh $ssh_servers[1]" C-m

    for host in $ssh_servers[2..-1]
        tmux split-window -h "ssh $host"
        tmux select-layout tiled >/dev/null
    end

    if test (count $ssh_servers) -gt 1
        tmux select-pane -t 0
        tmux set-window-option synchronize-panes on
        tmux rename-window "$multi_filename"
    end
end
