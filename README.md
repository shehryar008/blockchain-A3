# Supply Chain Management DApp using Polygon and Hardhat

Prepared by: **Shehryar Ahmed**

## Overview
This project tracks a product through the supply chain:
Manufacturer -> Distributor -> Retailer -> Customer

It includes:
- Solidity smart contract with role-based access control
- Hardhat deployment and testing
- Polygon Amoy deployment configuration
- Simple HTML/JS frontend using Ethers.js

## Folder structure
- `contracts/ShehryarAhmedSupplyChain.sol`
- `scripts/deploy.js`
- `test/ShehryarAhmedSupplyChain.js`
- `frontend/index.html`
- `docs/report.docx`

## Setup
1. Install Node.js.
2. Run:
   ```bash
   npm install
   ```
3. Create a `.env` file with:
   ```bash
   POLYGON_AMOY_RPC_URL=https://rpc-amoy.polygon.technology/
   PRIVATE_KEY=your_wallet_private_key
   POLYGONSCAN_API_KEY=your_polygonscan_api_key
   ```

## Compile
```bash
npm run compile
```

## Test
```bash
npm test
```

## Deploy to Polygon Amoy
```bash
npm run deploy:amoy
```

After deployment, copy the printed:
- contract address
- deployment transaction hash

Then paste the address into `frontend/index.html`.

## Verify
```bash
npm run verify:amoy -- <DEPLOYED_CONTRACT_ADDRESS> <ADMIN_ADDRESS>
```

## Notes
Polygon's official docs currently direct new deployments to the Amoy testnet; Mumbai is marked deprecated. If your instructor specifically wants Mumbai, mention the deprecation and submit the Amoy deployment as the current Polygon testnet equivalent.
