// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../src/call/call.sol";
import "../src/call/solve.sol";

// Flag: flag{0xda0b5e252cfd5b31e5849642f549134fb5304d6c}

contract SimpleCall is Script {
    address contractAddress = vm.envAddress("CONTRACT_ADDRESS");
    uint256 playerKey = vm.envUint("PRIVATE_KEY");

    function setUp() public {}

    function run() public {
        ExistingStock cAdd = ExistingStock(contractAddress);

        vm.startBroadcast(playerKey);
        SolveCall solve = new SolveCall(address(cAdd));
        solve.entry();

        vm.stopBroadcast();
        require(cAdd.isSolved(), "challenge not solved");
    }
}
