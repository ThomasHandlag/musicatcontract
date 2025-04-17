import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const MusiCatModule = buildModule("MusiCatModule", (m) => {
    const musiCat = m.contract("MusiCat");
    return { musiCat };
});

export default MusiCatModule;