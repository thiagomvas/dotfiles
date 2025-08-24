function dsh --description 'Fuzzy select running container and open a shell'
    set c (docker ps --format '{{.Names}}' | fzf --prompt='container> ')
    if test -n "$c"
        docker exec -it $c bash
    end
end
