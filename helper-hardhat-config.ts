export const developmentChains = ["hardhat", "localhost"];
export const testChains = ["goerli"];

export const networkConfig: any = {
  31337: {
    name: "localhost",
    scanAPIKey: process.env.ETHERSCAN_API_KEY,
    // dsphToken: "",
    // usdtToken: ""
  },

  5: {
    name: "goerli",
    scanAPIKey: process.env.ETHERSCAN_API_KEY,
    // dsphToken: "",
    // usdtToken: ""
  },
  1: {
    name: "mainnet",
    scanAPIKey: process.env.ETHERSCAN_API_KEY,
    // dsphToken: "",
    // usdtToken: ""
  },
  56: {
    name: "bsc_mainnet",
    scanAPIKey: process.env.POLYGONSCAN_API_KEY,
    dsphToken: "0x6de9a8d7f691362a14d35b5751fd394842a0ecdc",
    usdtToken: "0x55d398326f99059ff775485246999027b3197955"
  },
  97: {
    name: "bsc_testnet",
    scanAPIKey: process.env.POLYGONSCAN_API_KEY,
    dsphToken: "0x6de9A8D7F691362A14D35b5751fD394842a0ecdc",
    usdtToken: "0x377533D0E68A22CF180205e9c9ed980f74bc5050"
  },
};

export const VERIFICATION_BLOCK_CONFIRMATIONS = 6;
