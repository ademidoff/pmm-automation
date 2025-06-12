#!/bin/bash -e

docker exec -it pmm-server pmm-admin remove valkey valkey-svc1 || :
docker exec -it pmm-server pmm-admin remove valkey valkey-svc2 || :
docker exec -it pmm-server pmm-admin remove valkey valkey-svc3 || :

docker rm -vf valkey1 valkey2 valkey3 valkey1-replica1 valkey2-replica1 valkey3-replica1
rm -rf "$HOME/valkey"
