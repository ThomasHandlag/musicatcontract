import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const DeployModules = buildModule("DeployModules", (m) => {
    const marketPlace = m.contract("MarketPlace");
    const musiCat = m.contract("MusiCat");
    return { marketPlace, musiCat };
});

export default DeployModules;