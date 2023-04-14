export const developmentChains = ["hardhat", "localhost"];
export const testChains = ["goerli"];

export const networkConfig: any = {
  31337: {
    name: "localhost",
    // dsphToken: "",
    // usdtToken: ""
  },

  5: {
    name: "goerli",
    // dsphToken: "",
    // usdtToken: ""
  },
  1: {
    name: "mainnet",
    // dsphToken: "",
    // usdtToken: ""
  },
  56: {
    name: "bsc_mainnet",
    dsphToken: "0x6de9a8d7f691362a14d35b5751fd394842a0ecdc",
    usdtToken: "0x55d398326f99059ff775485246999027b3197955",
  },
  97: {
    name: "bsc_testnet",
    dsphToken: "0xCf8f7E720Ad2aD3f62C57f68a2F61Bb4ede7B3eB",
    usdtToken: "0xb59Df32E1450aEAb8aFbCDbb19220aB8ca6C3ab4",
  },
};

export const VERIFICATION_BLOCK_CONFIRMATIONS = 6;
