function fh --description 'Fuzzy-search command history and run selection'
    if not type -q fzf
        echo "fzf not installed"
        return 1
    end
    set -l selection (history | string replace -r '^\s*\d+\s*' '' | fzf --reverse --prompt="history> ")
    if test -n "$selection"
        eval $selection
    end
end