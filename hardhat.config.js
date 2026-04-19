require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

const { POLYGON_AMOY_RPC_URL, PRIVATE_KEY, POLYGONSCAN_API_KEY } = process.env;

module.exports = {
  solidity: {
    version: "0.8.24",
    settings: {
      optimizer: { enabled: true, runs: 200 }
    }
  },
  networks: {
    hardhat: {},
    amoy: {
      url: POLYGON_AMOY_RPC_URL || "",
      accounts: PRIVATE_KEY ? [PRIVATE_KEY] : [],
      chainId: 80002
    }
  },
  etherscan: {
    apiKey: {
      amoy: POLYGONSCAN_API_KEY || ""
    }
  }
};
