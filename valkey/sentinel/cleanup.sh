#!/bin/bash -e

# docker exec -it pmm-server pmm-admin remove valkey valkey-svc1 || :
# docker exec -it pmm-server pmm-admin remove valkey valkey-svc2 || :
# docker exec -it pmm-server pmm-admin remove valkey valkey-svc3 || :

docker rm -vf valkey-primary valkey-replica-1 valkey-replica-2 || true
docker rm -vf sentinel-1 sentinel-2 sentinel-3 || true

docker volume rm -f valkey-primary-data valkey-replica-1-data valkey-replica-2-data || true

rm -rf "$HOME/valkey"

