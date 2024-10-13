# About

1. Create a Basic AA on ethereum
2. Create a Basic AA on zkSync
3. Deploy and send a userOp / transaction through them
   1. Not going to send an AA to Ethereum
   2. But we will send an AA tx to zkSync

Here’s a **README** file for your Account Abstraction project:

---

# Minimal Account Abstraction Project

## Overview

This project implements **Account Abstraction (AA)** on Ethereum. The goal of account abstraction is to decouple Ethereum accounts from users' private keys, enabling smart contracts to serve as flexible, programmable wallets. In this project, a smart contract wallet (`MinimalAccount`) is created, which can interact with the blockchain through a central "EntryPoint" contract. The smart wallet can validate and execute transactions, handle signatures, and even pay for gas fees.

### Key Features:

- **Smart Wallet (MinimalAccount):** Acts as an account that can validate signatures and execute functions on behalf of the user.
- **Account Abstraction (AA):** Simplifies user interaction with the blockchain by abstracting away private key management and allowing a contract to act as an account.
- **EntryPoint Contract:** A middleman that facilitates and verifies the execution of user operations.
- **Packed User Operations:** Bundles transaction information and signatures for seamless processing by the EntryPoint.

## Project Structure

```
.
├── src
│   └── ethereum
│       └── MinimalAccount.sol       # Smart contract acting as an Account Abstraction wallet
├── script
│   ├── DeployMinimal.s.sol          # Script for deploying the MinimalAccount contract
│   ├── HelperConfig.s.sol           # Helper config contract managing network-specific data
│   └── SendPackedUserOp.s.sol       # Script to generate, sign, and send User Operations
└── lib
    └── account-abstraction          # External library for Account Abstraction utilities and interfaces
```

## Contracts

### 1. **MinimalAccount.sol**

This contract is the central smart contract wallet for the Account Abstraction setup. It manages the following:

- **`execute()`**: Executes transactions on behalf of the account owner.
- **`validateUserOp()`**: Verifies the signature of the UserOperation sent to the EntryPoint.
- **`_validateSignature()`**: Confirms that the signature belongs to the account owner.
- **`_payPrefund()`**: Prefunds gas fees required for executing the transaction.
- **Owner Management**: Only the account owner or EntryPoint is authorized to execute actions.

### 2. **HelperConfig.s.sol**

This contract provides network-specific configuration details, such as:

- The address of the EntryPoint contract.
- The account details used for deployment.
  It dynamically adjusts based on the blockchain being used (local, Sepolia, or zkSync).

### 3. **DeployMinimal.s.sol**

This is a script used for deploying the `MinimalAccount` contract to a specified blockchain network. It uses configurations from `HelperConfig` to set up the correct EntryPoint and account details.

### 4. **SendPackedUserOp.s.sol**

This script is used to generate and send **Packed User Operations** (a bundle containing the transaction details and signature) to the EntryPoint contract for execution. It follows these steps:

1. Generates unsigned data for the user operation.
2. Creates a UserOp hash for signing.
3. Signs the transaction using a private key.
4. Encodes the transaction and prepares it for submission.

## Prerequisites

Ensure you have the following tools installed:

- [Foundry](https://getfoundry.sh/) - for smart contract development and testing.
- [Forge](https://book.getfoundry.sh/) - the development framework used for writing and deploying contracts.
- [Node.js](https://nodejs.org/en/) - for interacting with the blockchain.
- [Solidity](https://soliditylang.org/) - smart contract programming language.

## Installation

Clone the repository and install the dependencies:

```bash
git clone <your-repository-url>
cd <your-repository-directory>
```

Next, ensure all required libraries (like the `account-abstraction` package) are installed by running:

```bash
forge install
```

## Deployment

To deploy the `MinimalAccount` contract, execute the deployment script:

```bash
forge script script/DeployMinimal.s.sol --broadcast --rpc-url <YOUR_RPC_URL>
```

This will deploy the `MinimalAccount` smart contract to the network specified by your `rpc-url`.

## Running Tests

You can write and run tests using Foundry. If you have written test cases, simply run:

```bash
forge test
```

## How it Works

1. **Deploying MinimalAccount:**  
   You deploy the `MinimalAccount` contract which represents a smart wallet owned by a user.

2. **Validating Operations:**  
   The EntryPoint contract ensures that only valid User Operations, signed by the smart wallet owner, are executed. This means the wallet only processes transactions that the owner has signed.

3. **Sending Operations:**  
   User operations are packaged with details like the function to execute, value of ETH to send, and signature. These operations are sent to the EntryPoint contract, which validates them and forwards them to the correct destination.

## Example Usage

1. Deploy the `MinimalAccount` contract using the `DeployMinimal.s.sol` script.
2. Use the `SendPackedUserOp.s.sol` script to create and send a valid User Operation to the EntryPoint. This operation can include things like calling a function on another contract, transferring ETH, or interacting with a dApp.

## Configuration

The project dynamically configures itself based on the chain it’s running on (local Anvil, Ethereum Sepolia, or zkSync Sepolia). You can modify the chain-specific settings in `HelperConfig.s.sol`. For example:

```solidity
if (chainId == LOCAL_CHAIN_ID) {
    return getOrCreateAnvilEthConfig();
} else if (networkConfigs[chainId].account != address(0)) {
    return networkConfigs[chainId];
} else {
    revert HelperConfig__InvalidChainId();
}
```

## Future Improvements

- Adding more complex account abstraction features like multi-signature validation, social recovery, or token-based gas payments.
- Supporting more blockchain networks and adding advanced configurations for different environments.
- Writing more detailed test cases to ensure the robustness of the `MinimalAccount` contract.

## License

This project is licensed under the MIT License.

---

Feel free to modify and adapt this README file according to your project needs!
