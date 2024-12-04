#!/usr/bin/env bash

docker compose down --volumes

rm -rf data/validator1/caches \
       data/validator1/database \
       data/validator1/besu.networks \
       data/validator1/besu.ports \
       data/validator1/DATABASE_METADATA.json \
       data/validator1/VERSION_METADATA.json \
       data/validator2/caches \
       data/validator2/database \
       data/validator2/besu.networks \
       data/validator2/besu.ports \
       data/validator2/DATABASE_METADATA.json \
       data/validator2/VERSION_METADATA.json \
       data/validator3/caches \
       data/validator3/database \
       data/validator3/besu.networks \
       data/validator3/besu.ports \
       data/validator3/DATABASE_METADATA.json \
       data/validator3/VERSION_METADATA.json \
       data/validator4/caches \
       data/validator4/database \
       data/validator4/besu.networks \
       data/validator4/besu.ports \
       data/validator4/DATABASE_METADATA.json \
       data/validator4/VERSION_METADATA.json \
       data/ipfs data/postgres data/caches data/database \
       configs/.vault/file \
       configs/.vault/data/init.out