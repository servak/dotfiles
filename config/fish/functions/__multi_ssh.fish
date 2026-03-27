function __multi_ssh
    if not test -f ~/.ssh/known_hosts
        return 1
    end

    set -l ssh_servers (sed -e 's/[, ].*$//' ~/.ssh/known_hosts | sort -u | __dotfiles_fzf_select_multi (commandline))
    if test (count $ssh_servers) -eq 0
        return 0
    end

    commandline --replace "ssh $ssh_servers[1]"
    commandline -f execute
    commandline -f repaint

    if not set -q TMUX
        return 0
    end

    for host in $ssh_servers[2..-1]
        tmux split-window -h "ssh $host"
        tmux select-layout tiled >/dev/null
    end

    if test (count $ssh_servers) -gt 1
        tmux select-pane -t 0
        tmux set-window-option synchronize-panes on
        tmux rename-window ssh-multi
    end
end
