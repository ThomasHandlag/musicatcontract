import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const DeployModules = buildModule("DeployModules", (m) => {
    const deployer = m.getAccount(1);
    const marketPlace = m.contract("MarketPlace", [deployer]);
    const musiCat = m.contract("MusiCat");
    return { marketPlace, musiCat };
});

export default DeployModules;