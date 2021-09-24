require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-ethers")
require('hardhat-deploy');
require('hardhat-contract-sizer');
require("hardhat-gas-reporter");

require('dotenv').config();

// tasks
require('./tasks/accounts');
require('./tasks/fund-eth');

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.4",
  networks: {
    hardhat: { // id: 31337
      forking: {
        url: 'https://eth-mainnet.alchemyapi.io/v2/'+process.env.ALCHEMY_KEY,
        blocknumber: 13063286
      }
    }
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_KEY
  },
  namedAccounts: {
    deployer: {
      default: 0,
      1: 0
    }
  },
  contractSizer: {
    alphaSort: true,
    runOnCompile: false,
    disambiguatePaths: false,
  },
  gasReporter: {
    enabled: true,
    currency: 'USD',
    gasPrice: 30,
    coinmarketcap: process.env.COINMARKETCAP_API_KEY
  }
};
