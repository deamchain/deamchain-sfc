/**
 *Submitted for verification at FtmScan.com on 2021-03-10
*/

pragma solidity ^0.5.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable {
		address private _owner;

		event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

		/**
		 * @dev Initializes the contract setting the deployer as the initial owner.
		 */
		constructor () internal {
			address msgSender = msg.sender;
			_owner = msgSender;
			emit OwnershipTransferred(address(0), msgSender);
		}

		/**
		 * @dev Returns the address of the current owner.
		 */
		function owner() public view returns (address) {
				return _owner;
		}

		/**
		 * @dev Throws if called by any account other than the owner.
		 */
		modifier onlyOwner() {
				require(isOwner(), "Ownable: caller is not the owner");
				_;
		}

		/**
		 * @dev Returns true if the caller is the current owner.
		 */
		function isOwner() public view returns (bool) {
				return msg.sender == _owner;
		}

		/**
		 * @dev Leaves the contract without owner. It will not be possible to call
		 * `onlyOwner` functions anymore. Can only be called by the current owner.
		 *
		 * NOTE: Renouncing ownership will leave the contract without an owner,
		 * thereby removing any functionality that is only available to the owner.
		 */
		function renounceOwnership() public onlyOwner {
				emit OwnershipTransferred(_owner, address(0));
				_owner = address(0);
		}

		/**
		 * @dev Transfers ownership of the contract to a new account (`newOwner`).
		 * Can only be called by the current owner.
		 */
		function transferOwnership(address newOwner) public onlyOwner {
				_transferOwnership(newOwner);
		}

		/**
		 * @dev Transfers ownership of the contract to a new account (`newOwner`).
		 */
		function _transferOwnership(address newOwner) internal {
				require(newOwner != address(0), "Ownable: new owner is the zero address");
				emit OwnershipTransferred(_owner, newOwner);
				_owner = newOwner;
		}
}

contract StakersInterface {
	function getValidatorID(address addr) external view returns (uint256);
}

contract StakerInfo is Ownable {
	mapping (uint => string) public stakerInfos;

	address internal stakerContractAddress = 0xeAb1000000000000000000000000000000000000;
	constructor(bool mainnet) public {
		string memory _configUrl = "https://ipfs.io/ipfs/QmZZ99gTyJt5C22tV5SDMj3T2AdbCSx95yRDCLiHn2FajF";
		if (mainnet) {
			_updateInfo(0x11111111aCC5167eC76ba11Bfc8e6Aa595b816B7, _configUrl);
			_updateInfo(0x22222222cfaecf02D2Ec037D070996e1E933B655, _configUrl);
			_updateInfo(0x33333333A4c641FC9a8A1BF806Af683Fc9bd89E9, _configUrl);
			_updateInfo(0x4444444448bdfFb42257449f2730Ba9400F41103, _configUrl);
			_updateInfo(0x555555555033c16772201210A1B0062ADf0Fe0b8, _configUrl);
			_updateInfo(0x66666666061c2cb748fF9Acb790E7ffC37496F45, _configUrl);
			_updateInfo(0x777777775ad670e03C31b549F132CbcA7E17A7Cd, _configUrl);
			_updateInfo(0x8888880A30642CFdB618F176ddA8f14276a3e2Ff, _configUrl);
		} else {
			_updateInfo(0x1100FF293E6DBF8ab29077d048c5FbA0AD68E45E, _configUrl);
			_updateInfo(0x2200cEE5dB1506C1BD3d4606A02B25EFa04040A1, _configUrl);
			_updateInfo(0x330021E57830B5ec84E01C15dD41baBdF40Fe8eD, _configUrl);
			_updateInfo(0x4400272572eB58878ec90e9e6D7d5Bf9eBB2Da4B, _configUrl);
			_updateInfo(0x55009E1f4a9069ca9a423a7295D02e946874501F, _configUrl);
			_updateInfo(0x660008eaecfd46Eb085EFeb9CCdeC9ebB17f76b9, _configUrl);
			_updateInfo(0x770098CC94b51f6D4d42fD944761608Fa04978D9, _configUrl);
			_updateInfo(0x8800a07d588412D6dBa94c34d73D0cB53fFb618A, _configUrl);
		}
	}

	event InfoUpdated(uint256 stakerID);

	function updateInfo(string calldata _configUrl) external {
		require(msg.sender!=address(0));
		_updateInfo(msg.sender, _configUrl);
	}

	function _updateInfo(address _sender, string memory _configUrl) internal {
		StakersInterface stakersInterface = StakersInterface(stakerContractAddress);

		// Get staker ID from staker contract
		uint256 stakerID = stakersInterface.getValidatorID(_sender);

		// Check if address belongs to a staker
		require(stakerID != 0, "Address does not belong to a staker!");

		// Update config url
		stakerInfos[stakerID] = _configUrl;

		emit InfoUpdated(stakerID);
	}

	function getInfo(uint256 _stakerID) external view returns (string memory) {
		return stakerInfos[_stakerID];
	}
}