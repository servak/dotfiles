# 基本設定
setopt auto_cd # cdを自動挿入
setopt auto_pushd # pushdを自動で行う
setopt pushd_ignore_dups # 重複するディレクトリは保存しない
setopt correct # command correct edition before each completion attempt
setopt list_packed # 補完候補を表示するときにつめて表示
setopt noautoremoveslash # no remove postfix slash of command line
setopt nolistbeep # no beep sound when complete list displayed
setopt nonomatch # no match *
setopt print_eight_bit #日本語ファイル名等8ビットを通す
setopt extended_glob # 拡張グロブで補完(~とか^とか。例えばless *.txt~memo.txt ならmemo.txt 以外の *.txt にマッチ)
# setopt globdots # 明確なドットの指定なしで.から始まるファイルをマッチ

umask 022
export WORDCHARS="*?_-.[]~&;!#$%^(){}<>" # 単語に引っかからない記号を定義