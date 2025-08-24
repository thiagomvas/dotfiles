function gco --description 'Fuzzy checkout branch (local + remote)'
    set -l branch (git branch --all --color=never | sed 's/^[ *]*//' | fzf --prompt="branch> ")
    if test -n "$branch"
        # ease remote/refs names
        set branch (string replace -r '^remotes/[^/]*/' '' $branch)
        git checkout $branch
    end
end
