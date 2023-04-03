// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../src/hexp/hexp.sol";

contract WalletScript is Script {
    address contractAddress = vm.envAddress("CONTRACT_ADDRESS");
    uint256 playerKey = vm.envUint("PRIVATE_KEY");
    Hexp challenge;

    function setUp() public {
        challenge = new Hexp();
    }

    function run() public {
        // Blockhash(Block number - 0xa) & 0xffffff
        // Gasprice & 0xffffff
        require(challenge.isSolved(), "challenge not solved");
    }
}
