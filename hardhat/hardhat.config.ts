import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";

dotenv.config();

const deployerPrivateKey = process.env.DEPLOYER_PRIVATE_KEY;
if (!deployerPrivateKey) throw Error("Deployer Private Key Env not set");

const playerPrivateKey = process.env.PLAYER_PRIVATE_KEY;
if (!playerPrivateKey) throw Error("Player private key env not set");


const config: HardhatUserConfig = {
  solidity: "0.8.18",
  defaultNetwork: "localhost",
  networks: {
    localhost: {
      url: "http://localhost:8545",
      accounts: [deployerPrivateKey, playerPrivateKey]
    },
  }
};

export default config;
