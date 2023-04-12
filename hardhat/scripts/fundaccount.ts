
import { ethers } from "hardhat";

const formatEther = ethers.utils.formatEther;
const parseEther = ethers.utils.parseEther;

async function main() {
  const [deployer, player] = await ethers.getSigners();

  const res = await deployer.sendTransaction({
    to: await player.address,
    value: parseEther("1")
  });

  await res.wait();
  const bal = await ethers.provider.getBalance(player.address);
  console.log("Funded player account with 1 ether", formatEther(bal));
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
