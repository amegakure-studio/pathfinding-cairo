# Setup Account

## Install dependencies

- [Starkli](https://book.starkli.rs/) - Command line tool for interacting with Starknet.

If you're on Linux/macOS/WSL, you can install starkliup by running the following command:

```bash
curl https://get.starkli.sh | sh
```

You might need to restart your shell session for the starkliup command to become available. Once it's available, run the starkliup command:

```bash
starkliup --version 0.1.20
```
Running the commands installs starkli for you, and upgrades it to the latest release if it's already installed.

## Setting up a Starknet Testnet Wallet

**This guide will help you declare and deploy contracts on a testnet. Please
note that you won't be able to use the commands in the Makefile unless you
follow these instructions.**

A smart wallet consists of two parts: a Signer and an Account Descriptor. The
Signer is a smart contract capable of signing transactions (for which we need
its private key). The Account Descriptor is a JSON file containing information
about the smart wallet, such as its address and public key.

Follow the steps below to set up a testnet smart wallet using `starkli`:

1. **Connect to a Provider**: to interact with the network you need an RPC
   Provider. For our project we will be using Alchemy's free tier in Goerli
   Testnet.

   1. Go to [Alchemy website](https://www.alchemy.com/) and create an account.
   2. It will ask which network you want to develop on and choose Starknet.
   3. Select the Free version of the service (we will only need access to send
      some transactions to deploy the contracts)
   4. Once the account creation process is done, go to _My apps_ and create a
      new Application. Choose Starknet as a Chain and Goerli Starknet as a
      Network.
   5. Click on _View key_ on the new Starknet Application and copy the HTTPS
      url.
   6. Updated `.env` file:

      ```bash
      RPC_URL="<ALCHEMY_API_HTTPS_URL>"
      ```
2. **Create a Keystore**: A Keystore is a encrypted `json` file that stores the
   private keys.

   1. **Create a hidden folder**: Use the following command:

      ```bash
      mkdir -p ~/.starkli-wallets
      ```
   2. **Generate a new Keystore file**: Run the following command to create a
      new private key stored in the file. It will **ask for a password** to
      encrypt the file:

      ```bash
      starkli signer keystore new ~/.starkli-wallets/keystore.json
      ```

      The command will return the Public Key of your account, copy it to your
      clipboard to fund the account.

3. **Account Creation**: In Starknet every account is a smart contract, so to
   create one it will need to be deployed.

   1. **Initiate the account with the Open Zeppelin Account contract**:

      ```bash
      starkli account oz init --keystore ~/.starkli-wallets/keystore.json ~/.starkli-wallets/account.json
      ```
   2. **Deploy the account by running**:

      ```bash
      starkli account deploy --keystore ~/.starkli-wallets/keystore.json ~/.starkli-wallets/account.json
      ```

      For the deployment `starkli` will ask you to fund an account. To do so
      you will need to fund the address given by `starkli` with the
      [Goerli Starknet Faucet](https://faucet.goerli.starknet.io)

4. **Setting Up Environment Variables**: There are two primary environment
   variables vital for effective usage of Starkli’s CLI. These are the location
   of the keystore file for the Signer, and the location of the Account.

   Updated `.env` file:

   ```
   # Path of the keystore and the account created with starkli commands.
   ACCOUNT_SRC=~/.starkli-wallets/account.json
   KEYSTORE_SRC=~/.starkli-wallets/keystore.json
   # This password should be the same as when we execute the command 'starkli signer keystore new ~/.starkli-wallets/keystore.json'
   KEYSTORE_PASSWORD=<KEYSTORE_PASSWORD>
   # This is a public RPC provided by Blast (https://blastapi.io/public-api/starknet) 
   RPC_URL=https://starknet-mainnet.public.blastapi.io/rpc/v0_6
   ```