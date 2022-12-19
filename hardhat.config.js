require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

const TESTNET_RPC = process.env.TESTNET_RPC;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const POLYGONSCAN_API_KEY = process.env.POLYGONSCAN_API_KEY;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  networks: {
    mumbai: {
      url: TESTNET_RPC,
      accounts: [PRIVATE_KEY],
    },
  },
  etherscan: {
    apiKey: POLYGONSCAN_API_KEY,
  },
};
