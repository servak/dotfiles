function fish_user_key_bindings
    bind \e\[1\~ beginning-of-line
    bind \e\[4\~ end-of-line
    bind \e\[3\~ delete-char

    bind \cp up-or-search
    bind \cn down-or-search
    bind \e\p up-or-search
    bind \e\n down-or-search
    bind \e\[Z history-pager

    bind \cj __smart_enter
    bind \x00 __cmdsearch
    bind \eg __ghq_cd
    bind \ev __vim_file_search
    bind \es __multi_ssh
    bind \eu __cdup
end
