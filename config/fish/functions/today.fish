function today
    set -l target_dir "$HOME/work/"(date '+%Y/%m/%d')
    mkdir -p "$target_dir"
    and cd "$target_dir"
end
