import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const MarketPlaceModule = buildModule("MarketPlaceModule", (m) => {
    const marketPlace = m.contract("MarketPlace");
    return { marketPlace };
});

export default MarketPlaceModule;