import { ethers } from "hardhat";

// Ensure player account has funds before starting

async function main() {
 
  const [deployer, player] = await ethers.getSigners();

  const balance = await player.getBalance();
  if ( balance.isZero()) {
    throw Error("Player Balance is 0");
  }

  const challenge = await setupChallenge();


  const hexp = challenge.connect(player);
  const currentBlockNumber = await ethers.provider.getBlockNumber();
  const prevBlockHash = (await ethers.provider.getBlock(currentBlockNumber - 9)).hash;
  const last3 = prevBlockHash.slice(-6);
  console.log(last3)

  const res = await hexp.f00000000_bvvvdlt({
    gasPrice: parseInt(last3, 16),
    gasLimit: 1e6
  });
  await res.wait();

  console.log(await hexp.isSolved());
}

async function setupChallenge() {
  const [deployer] = await ethers.getSigners();
  const hexpFactory = await ethers.getContractFactory("Hexp", deployer);
  const hexp = await hexpFactory.deploy();
  await hexp.deployTransaction.wait();

  return hexp;
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
