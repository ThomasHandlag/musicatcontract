import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const MSCerModule = buildModule("MSCerModule", (m) => {
    const mscer = m.contract("MSCer");
    return { mscer };
});

export default MSCerModule;