// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../src/asslot/asslot.sol";
import "../src/asslot/solve.sol";

contract AsslotScript is Script {
    address contractAddress = vm.envAddress("CONTRACT_ADDRESS");
    uint256 playerKey = vm.envUint("PRIVATE_KEY");
    Asslot challenge;

    function setUp() public {
        challenge = new Asslot();
    }

    function run() public {
        Solve s = new Solve(address(challenge));
    }
}
