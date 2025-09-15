function dcdall
    for file in (find . -type f -name 'docker-compose.dev.yml' -o -name 'docker-compose.infra.yml')
        echo "Stopping Docker Compose in (dirname $file)..."
        docker compose -f $file down
    end
end
