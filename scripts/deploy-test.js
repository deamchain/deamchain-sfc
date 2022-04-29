require('dotenv').config();
require("colors")
const fs = require("fs")
/* ; */

/* ; */
/* const { ethers } = require("hardhat"); */
/* const SFCAbi = require("../artifacts/contracts/sfc/SFC.sol/SFC.json").abi; */
/* const StakerInfoAbi = require("../artifacts/contracts/sfc/StakerInfo.sol/StakerInfo.json").abi; */

async function main() {
	// get network
	var [deployer] = await ethers.getSigners();

	/* let network = await deployer.provider._networkPromise;
	let chainId = network.chainId; */

	console.log("deployer", deployer.address);

	let sDEAM;
	let stakeTokenizer;
	let stakerInfo;

	/* ----------- sDEAM -------------- */
	//deploy SDEAM contract for test
	const SDEAM = await ethers.getContractFactory("SDEAM");
	sDEAM = await SDEAM.deploy();
	await sDEAM.deployed();

	const StakeTokenizer = await ethers.getContractFactory("StakeTokenizer");
	stakeTokenizer = await StakeTokenizer.deploy(sDEAM.address);
	await stakeTokenizer.deployed();

	let tx = await sDEAM.addMinter(stakeTokenizer.address);
	await tx.wait();

	// stakerInfo
	const StakerInfo = await ethers.getContractFactory("StakerInfo");
	stakerInfo = await StakerInfo.deploy(false);
	await stakerInfo.deployed();

	//sfc
	// const sFC = new ethers.Contract("0x1c1cB00000000000000000000000000000000000",SFCAbi,sfcOwner);
	// tx = await sFC.updateStakeTokenizerAddress(stakeTokenizer.address);
	// await tx.wait();

	console.log("SDEAM : ", sDEAM.address);
	console.log("StakeTokenizer : ", stakeTokenizer.address);
	console.log("StakerInfo : ", stakerInfo.address);

	fs.writeFileSync(__dirname + '/contracts.json', JSON.stringify({
		SDEAM: sDEAM.address,
		StakeTokenizer: stakeTokenizer.address,
		StakerInfo: stakerInfo.address
	}))
}

main().then(() => console.log("complete".green)).catch((error) => {console.error(error);process.exit(1);});
