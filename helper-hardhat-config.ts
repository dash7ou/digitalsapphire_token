export const developmentChains = ["hardhat", "localhost"];
export const testChains = ["goerli"];

export const networkConfig: any = {
  31337: {
    name: "localhost",
    scanAPIKey: process.env.ETHERSCAN_API_KEY,
  },

  5: {
    name: "goerli",
    scanAPIKey: process.env.ETHERSCAN_API_KEY,
  },
  1: {
    name: "mainnet",
    scanAPIKey: process.env.ETHERSCAN_API_KEY,
  },
  56: {
    name: "bsc_mainnet",
    scanAPIKey: process.env.POLYGONSCAN_API_KEY,
  },
  97: {
    name: "bsc_testnet",
    scanAPIKey: process.env.POLYGONSCAN_API_KEY,
  },
};

export const VERIFICATION_BLOCK_CONFIRMATIONS = 6;
