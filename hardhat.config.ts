import type { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox-viem";

const config: HardhatUserConfig = {
  solidity: "0.8.28",
  networks: {
    geth: {
      url: "http://10.50.158.131:8545",
      chainId: 31337,
    },
    geth1: {
      url: "http://192.168.100.211:8545",
      chainId: 31337,
    }
  }
};

export default config;
