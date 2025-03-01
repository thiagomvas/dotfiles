function paabm
    set sourceFile $argv[1]
    set execName $argv[2]

    if test -z "$sourceFile" -o -z "$execName"
        echo "Usage: paabm <sourceFile> <execName>"
        return 1
    end

    clear && g++ -Wall -O3 -o "$execName" "$sourceFile" -lm -lpthread && hyperfine "./$execName inputs/$execName outputs/$execName" && rm -f "$execName"
end
