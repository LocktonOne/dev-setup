
# usage: ./start.sh INSTANCE_TYPE 
# Instance type is specifying the docker image to take:
# see https://hub.docker.com/r/matterlabs/local-node/tags for full list.
# latest2.0 - is the 'main' one.

INSTANCE_TYPE=${1:-latest2.0}

export INSTANCE_TYPE=$INSTANCE_TYPE
docker compose up -d \
      validator1 validator2 validator3 validator4 


wait_till_rpc_work() {
  rpc_endpoint="http://localhost:8545/"
  response=$(curl -s -X POST \
  -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
  $rpc_endpoint);
  if echo "$response" | grep -q '"result"'; then
    return 0
  else
    return 1
  fi
}

# Loop until RPC works
while ! wait_till_rpc_work; do
  echo "RPC has not started yet, waiting..."
  sleep 10  # Check every 10 seconds
done

docker compose up -d \
      traefik faucet upstream vault \
      core-contracts \
      auth-db blob-db blob-svc keyserver-db keyserver-svc \
      redis issuer_db issuer issuer-integration-db issuer-integration-svc \
      graph-node ipfs graph-db \
      notifications-router_db notifications-router email-sender

wait_till_core_contracts_deployed() {
  vault_endpoint="http://localhost:8200/v1/cubbyhole/data/core-contracts"
  vault_token="my-token"
  response=$(curl -s -o /dev/null -w "%{http_code}" -H "X-Vault-Token: $vault_token" "$vault_endpoint")
  if [ "$response" -eq 200 ]; then
    return 0
  else
    return 1
  fi
}


wait_till_allowed_contracts_deployed() {
  vault_endpoint="http://localhost:8200/v1/cubbyhole/data/allowed-contract-registry"
  vault_token="my-token"
  response=$(curl -s -o /dev/null -w "%{http_code}" -H "X-Vault-Token: $vault_token" "$vault_endpoint")
  if [ "$response" -eq 200 ]; then
    return 0
  else
    return 1
  fi
}

# Loop until all services are healthy
while ! wait_till_core_contracts_deployed; do
  echo "Core contracts are not deployed yet, waiting..."
  sleep 15  # Check every 15 seconds
done

docker compose up -d \
      account-abstraction-contracts allowed-registry-contracts token-contracts kyc-contracts \
      doorman core-graph nonce-auth 

# Loop until all services are healthy
while ! wait_till_allowed_contracts_deployed; do
  echo "Allowed contract registry are not deployed yet, waiting..."
  sleep 15  # Check every 15 seconds
done

docker compose up -d rpc-wrapper bundler web-client 

echo "All services are healthy!"