const { expect } = require("chai");
const { ethers } = require("hardhat");

const {delay, fromBigNum, toBigNum} = require("./utils.js")

var owner;
var userWallet;
var stakerInfo;

describe("Create UserWallet", function () {
	it("Create account", async function () {
		[owner] = await ethers.getSigners();

		userWallet = ethers.Wallet.createRandom();
		userWallet = userWallet.connect(ethers.provider);
		var tx = await owner.sendTransaction({
			to: userWallet.address, 
			value:ethers.utils.parseUnits("100",18)
		});
		await tx.wait();	

		var sDEAM;
		var stakeTokenizer;
		/* ----------- sDEAM -------------- */
		//deploy SDEAM contract for test
		const SDEAM = await ethers.getContractFactory("SDEAM");
		sDEAM = await SDEAM.deploy();
		await sDEAM.deployed();

		const StakeTokenizer = await ethers.getContractFactory("StakeTokenizer");
		stakeTokenizer = await StakeTokenizer.deploy(sDEAM.address);
		await stakeTokenizer.deployed();

		var tx = await sDEAM.addMinter(stakeTokenizer.address);
		await tx.wait();

		// stakerInfo
		const StakerInfo = await ethers.getContractFactory("StakerInfo");
		stakerInfo = await StakerInfo.deploy();
		await stakerInfo.deployed();
	});
});
