function color256
    for code in (seq 0 255)
        printf "\e[38;5;%sm%03d\e[0m " $code $code
        if test (math "$code % 16") -eq 15
            echo
        end
    end
end
