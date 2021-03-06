/* hardhat.config.js */
require("@nomiclabs/hardhat-waffle")

const fs = require("fs")
const privateKey = fs.readFileSync(".secret").toString()
const projectId = "225a80cfaaaa4d30bfae406d996958b4"

module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      chainId: 1337
    },
    mumbai:{
      url: "https://polygon-mumbai.infura.io/v3/225a80cfaaaa4d30bfae406d996958b4",
      accounts: [privateKey]
    },  
    mainnet:{
      url: "https://polygon-mainnet.infura.io/v3/225a80cfaaaa4d30bfae406d996958b4",
      accounts: [privateKey]
    }
  },
  solidity: {
    version: "0.8.4",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  }
}