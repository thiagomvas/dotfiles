function extract --description 'extract <archive>'
    if test -z "$argv[1]"
        echo "usage: extract <archive>"
        return 1
    end
    set file $argv[1]
    switch (string lower (string sub -s -4 $file))
    case *.zip
        unzip $file
    case *.tar
        tar -xf $file
    case *.gz
        if string match -r '\.tar\.gz$' -- $file
            tar -xzf $file
        else
            gunzip $file
        end
    case *.xz
        if string match -r '\.tar\.xz$' -- $file
            tar -xJf $file
        else
            unxz $file
        end
    case *.bz2
        bunzip2 $file
    case '*'
        echo "Don't know how to extract $file"
        return 2
    end
end
