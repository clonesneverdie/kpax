const hre = require('hardhat')

async function main() {
  const Mix = await hre.ethers.getContractFactory('Mix')
  const mix = await mix.deploy()

  await mix.deployed()

  console.log('Mix deployed to:', mix.address)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
