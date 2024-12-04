## Lockton One Developer Edition

## Requirements
* [Docker 17.06.0+](https://www.docker.com/get-started)
* [Compose 1.29.0 <=, < 2.6.1](https://docs.docker.com/compose/install/)
* Linux

## Description
Quick way for running LocktonOne local development environment with Docker. 

## Quick start
### QBFT Configuration
For test purposes there is for validators. \
**Please use test keys only for local development**
The validators keys could be found at
```sh
./keys
```
For generating your own keys see [How to create a private network using QBFT](https://besu.hyperledger.org/private-networks/tutorials/qbft)

### LocktonOne configuration

1. Necessary updates:
* **Mailjet configuration:** Update Mailjet fields in `configs/email-sender.yaml` 
* **S3 configuration:** Update S3 fields for email templates `configs/notifications-router.yaml` 
2. Not necessary updates:
* **Predeployed permissions:** If you want to update roles or permissions, add new role to address see [Core contracts docs](https://github.com/LocktonOne/core-contracts/tree/master/docs)
* **Private keys**: If you generate new wallets make sure that you update all necessary private keys.
    * Configs
        * `doorman: service.token_key`. Need for checking users permission
        * `faucet: signer.eth_signer`. Treasure address from which tokens would be transfered
        * `nonce-auth: service.token_key`. Need for checking users permission
        * Currently in progress ~~`issuer-integration: network.private_key`~~. For setting ZKP Requests
    * Envs
        * `account-abstraction-contracts: PRIVATE_KEY` For deploying all contracts `and ADMIN_PRIVATE_KEY` for transfering money to `DEPLOYER_PRIVATE_KEY` which deploy entrypoint.
        * `allowed-contract-registry: PRIVATE_KEY` For deploying all contracts 
        * `core-contracts: PRIVATE_KEY` For deploying all contracts 
        * `kyc-contracts: PRIVATE_KEY` For deploying all contracts 
        * `token-contracts: PRIVATE_KEY` For deploying all contracts 
* **Vault config:** This environment uses dev mode on `Vault`. If you want to change it make sure you also update:
    * `configs/.vault`. There is a vault configuration
    * `configs/doorman`
    * `configs/rpc-wrapper`
    * `envs/account-abstraction-contracts`
    * `envs/allowed-contract-registry` 
    * `envs/core-contracts`
    * `envs/core-graph`
    * `envs/issuer`
    * `envs/kyc-contracts`
    * `envs/token-contracts`

### Start script
```sh
# drop any persistent state to make sure you are working with clean install
$ ./clear.sh
```
```sh
# spin everything up
$ ./start.sh
```
Now you should be able to access QBFT client using `validator1` [http://localhost:8545](http://localhost:8545) or permissioned RPC using `rpc-wrapper` [http://localhost:8554](http://localhost:8554)

## Metamask data
* Name : `LocktonOne`
* RPC URL: `http://localhost:8554`
* chainID: `9`
* Currensy symbol: `LCTN`

## Project status
Developing MVP.

