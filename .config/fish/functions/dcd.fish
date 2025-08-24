function dcd --description 'docker compose dev helper: usage dcd up|down|logs|attach'
    if test (count $argv) -ne 1
        echo "usage: dcd <command>"
        return 1
    end

    set cmd $argv[1]

    switch $cmd
        case up
            docker compose -f "docker-compose.dev.yml" up -d --build
        case down
            docker compose -f "docker-compose.dev.yml" down
        case logs
            docker compose -f "docker-compose.dev.yml" logs
        case attach
            docker compose -f "docker-compose.dev.yml" exec app bash
        case '*'
            echo "Unknown command: $cmd"
            return 2
    end
end