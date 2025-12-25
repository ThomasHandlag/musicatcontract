import { configVariable, defineConfig } from "hardhat/config";
import HardhatIgnitionEthersPlugin from "@nomicfoundation/hardhat-ignition-ethers";
import dotenv from "dotenv";
dotenv.config();

export default defineConfig({
  plugins: [HardhatIgnitionEthersPlugin],
  solidity: {
    profiles: {
      default: {
        version: "0.8.28",
      },
      production: {
        version: "0.8.28",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    },
  },

  networks: {
    geth: {
      url: "https://eth.bustify.dev",
      type: "http",
      chainId: 31337,
      accounts: [configVariable("ADMIN_KEY")],
    },
    local: {
      url: "http://localhost:8545",
      type: "http",
      chainId: 31337,
      accounts: [configVariable("ADMIN_KEY")],
    },
    hardhatMainnet: {
      type: "edr-simulated",
      chainType: "l1",
    },
    hardhatOp: {
      type: "edr-simulated",
      chainType: "op",
    },
    sepolia: {
      type: "http",
      chainType: "l1",
      url: configVariable("SEPOLIA_RPC_URL"),
      accounts: [configVariable("SEPOLIA_PRIVATE_KEY")],
    },
  },
});
