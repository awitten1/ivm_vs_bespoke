#!/usr/bin/env bash
# Start Postgres 18 with pg_ivm v1.17.
#   psql "postgres://postgres:postgres@localhost:${PORT:-5432}/postgres"
set -euo pipefail

name="${NAME:-pg_ivm}"
port="${PORT:-5432}"
password="${POSTGRES_PASSWORD:-postgres}"
image="${IMAGE:-pg_ivm:18}"
root="$(cd "$(dirname "$0")" && pwd)"

docker build -t "$image" "$root"

image_id="$(docker image inspect -f '{{.Id}}' "$image")"
if docker container inspect "$name" >/dev/null 2>&1; then
  current_id="$(docker inspect -f '{{.Image}}' "$name")"
  if [ "$current_id" != "$image_id" ]; then
    docker rm -f "$name" >/dev/null
  fi
fi

if docker container inspect "$name" >/dev/null 2>&1; then
  docker start "$name" >/dev/null
else
  docker run -d \
    --name "$name" \
    -e POSTGRES_PASSWORD="$password" \
    -p "${port}:5432" \
    "$image" \
    -c shared_preload_libraries=pg_ivm
fi

ready=0
for _ in $(seq 1 60); do
  if docker exec "$name" pg_isready -U postgres >/dev/null 2>&1; then
    ready=1
    break
  fi
  if [ "$(docker inspect -f '{{.State.Running}}' "$name")" != "true" ]; then
    docker logs "$name" >&2
    exit 1
  fi
  sleep 1
done
if [ "$ready" != 1 ]; then
  docker logs "$name" >&2
  exit 1
fi
docker exec -e PGPASSWORD="$password" "$name" \
  psql -U postgres -d postgres -v ON_ERROR_STOP=1 \
  -c "CREATE EXTENSION IF NOT EXISTS pg_ivm;"

echo "postgres://postgres:${password}@localhost:${port}/postgres"
