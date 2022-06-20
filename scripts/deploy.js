const hre = require("hardhat");
const fs = require('fs');

async function main() {
  const NFTticket_marketplace = await hre.ethers.getContractFactory("NFTticket_marketplace");
  const NFTticket_marketplace = await NFTticket_marketplace.deploy();
  await NFTticket_marketplace.deployed();
  console.log("NFTticket_marketplace deployed to:", NFTticket_marketplace.address);

  fs.writeFileSync('./config.js', `
  export const marketplaceAddress = "${NFTticket_marketplace.address}"
  `)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
