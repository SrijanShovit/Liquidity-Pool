const hre = require("hardhat");

async function main() {
  console.log("Deploying...")
  const MarketInteractions = await hre.ethers.getContractFactory("MarketInteractions");

  const AAVEPoolAddressProvider = "0xC911B590248d127aD18546B186cC6B324e99F02c";
  const linkAddress = "0xe9c4393a23246293a8D31BF7ab68c17d4CF90A29";
  const marketInteractions = await MarketInteractions.deploy(AAVEPoolAddressProvider,linkAddress);

  await marketInteractions.deployed();
  console.log("Market Interactions contract deployed: ",marketInteractions.address);//0x2BC008337426CFc5A97D1647cc9BF6aA104C71b9

  
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
