const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying with account:", deployer.address);

  const SupplyChain = await ethers.getContractFactory("ShehryarAhmedSupplyChain");
  const contract = await SupplyChain.deploy(deployer.address);

  await contract.waitForDeployment();
  const address = await contract.getAddress();

  console.log("Supply chain contract deployed to:", address);
  console.log("Deployment transaction hash:", contract.deploymentTransaction().hash);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
