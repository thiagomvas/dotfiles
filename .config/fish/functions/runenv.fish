function runenv --description 'Usage: runenv <env-file> <command> [...args] — set vars only for that command'
    if count $argv < 2
        echo "usage: runenv <env-file> <command> [...args]"
        return 2
    end

    set file $argv[1]
    set cmd $argv[2..-1]

    if not test -f $file
        echo "File not found: $file"
        return 1
    end

    set -l envs
    for line in (cat $file)
        set line (string trim $line)
        if test -z "$line" -o (string match -r '^\s*#' -- $line)
            continue
        end
        set parts (string split -m1 '=' -- $line)
        if test (count $parts) -lt 2
            continue
        end
        set key (string trim $parts[1])
        set val (string trim $parts[2])
        if string match -r '^".*"$' -- $val
            set val (string sub -s 2 -l (math (string length $val) - 2) $val)
        else if string match -r "^'.*'$" -- $val
            set val (string sub -s 2 -l (math (string length $val) - 2) $val)
        end
        set envs $envs "$key=$val"
    end

    env $envs $cmd
end
