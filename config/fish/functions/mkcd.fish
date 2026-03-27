function mkcd --argument dir
    if test -z "$dir"
        return 1
    end

    if test -d "$dir"
        cd "$dir"
    else
        mkdir -p "$dir"
        and cd "$dir"
    end
end
