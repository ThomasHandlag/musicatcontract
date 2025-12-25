import { network } from "hardhat";
import fs from "fs";

const main = async () => {
  console.log("Deploying Contract...");

  const { networkName, ethers } = await network.connect();

  const deployer = await ethers.getSigners();

  console.log(`Deploying contracts to ${networkName}...`);
  console.log("Deployer address:", deployer[0].address);

  const musicat = await ethers.getContractFactory("MusiCat");
  const musicatContract = await musicat.deploy();
  await musicatContract.waitForDeployment();
  const musicatAddress = await musicatContract.getAddress();
  console.log("MusiCat address ===> ", musicatAddress);

  const market = await ethers.getContractFactory("MarketPlace");
  const marketContract = await market.deploy(deployer[0].address);
  await marketContract.waitForDeployment();
  const marketAddress = await marketContract.getAddress();
  console.log("MarketPlace address ===> ", marketAddress);

  const mescat = await ethers.getContractFactory("Mescat");
  const mescatContract = await mescat.deploy();
  await mescatContract.waitForDeployment();
  const mescatAddress = await mescatContract.getAddress();
  console.log("Mescat address ===> ", mescatAddress);

  fs.writeFileSync(
    `./scripts/deployedAddresses_${networkName}.json`,
    JSON.stringify({ musicatAddress, marketAddress, mescatAddress }, null, 2)
  );

  console.log("Deployment successful!");
};

main().catch((error) => {
  console.error(error);
});
