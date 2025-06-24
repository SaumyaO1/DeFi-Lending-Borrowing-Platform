const { ethers } = require("hardhat");

async function main() {
  const LendingBorrowing = await ethers.getContractFactory("LendingBorrowing");
  const lendingBorrowing = await LendingBorrowing.deploy();

  await lendingBorrowing.deployed();

  console.log("LendingBorrowing deployed to:", lendingBorrowing.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
