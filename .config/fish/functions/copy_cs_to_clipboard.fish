function copy_cs_to_clipboard
    set folder (or $argv[1] .)
    find $folder -maxdepth 1 -type f -name "*.cs" -exec cat {} + | wl-copy
end
