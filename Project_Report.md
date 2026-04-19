# Supply Chain Management DApp
**Author:** Shehryar Ahmed
**Network:** Polygon Amoy Testnet

---

## 1. Project Overview
The Supply Chain Management Decentralized Application (DApp) is a blockchain-based solution designed to track and verify the lifecycle of a product from manufacturing to its final delivery. By leveraging smart contracts, the DApp provides an immutable, transparent, and secure audit trail of all product movements across various stakeholders in the supply chain.

## 2. Technology Stack
- **Smart Contracts:** Solidity (v0.8.24)
- **Framework:** Hardhat - used for compiling, testing, and deploying the contracts.
- **Blockchain Network:** Polygon Amoy Testnet
- **Frontend library:** Vanilla HTML/CSS/JavaScript with Tailwind CSS for rapid styling.
- **Web3 Interaction:** Ethers.js v6 for connecting the frontend UI to the deployed smart contracts via MetaMask.

## 3. Smart Contract Architecture
The core logic resides in the `ShehryarAhmedSupplyChain.sol` contract. It uses Role-Based Access Control (RBAC) to ensure only authorized entities can perform specific actions.

**Key Features:**
- **Product Registration:** Manufacturers can register new products, generating a unique ID along with its name and description.
- **Status Tracking:** The product moves through different lifecycle stages—`Manufactured`, `InTransit`, and `Delivered`.
- **Ownership Transfer:** Secure transfer functions move ownership progressively down the supply chain:
  - `transferToDistributor`
  - `transferToRetailer`
  - `transferToCustomer`
- **Audit Trail:** Every transfer step is recorded as a history entry, logging the actor, sender, receiver, timestamp, and status.

## 4. Frontend Application
The frontend is a single-page application that interacts directly with the smart contract. 
- **Wallet Connection:** Users connect their MetaMask wallet, which detects their account and network.
- **Role Interfaces:** The dashboard provides simple controls for registering new products and loading existing products to view their current custodians.
- **Audit Interface:** Users can input a "Product ID" to view a full cryptographic historical trace of the item, displaying timestamps and the Ethereum addresses of everyone who handled the product.

## 5. Deployment Information
The project was deployed and verified on the **Polygon Amoy Testnet** to ensure low-cost, high-speed transactions while maintaining Ethereum Virtual Machine (EVM) compatibility. 

- **RPC Used:** `https://rpc-amoy.polygon.technology/`
- **Wallet Provider:** MetaMask
- **Chain ID:** 80002

## 6. Usage Instructions
1. Clone the repository and install dependencies using `npm install`.
2. Configure environment variables (`PRIVATE_KEY`, `POLYGON_AMOY_RPC_URL`).
3. Compile the contracts: `npx hardhat compile`.
4. Run tests to ensure contract validity: `npx hardhat test`.
5. Deploy to the Amoy Testnet: `npx hardhat run scripts/deploy.js --network amoy`.
6. Launch the frontend using a local web server (e.g., `npx http-server ./frontend`).
7. Connect your MetaMask wallet (configured with the Amoy Testnet) to interact with the DApp.
