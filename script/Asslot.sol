// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../src/asslot/asslot.sol";
import {HuffDeployer} from "foundry-huff/HuffDeployer.sol";

contract AsslotScript is Script {
    address contractAddress = vm.envAddress("CONTRACT_ADDRESS");
    uint256 playerKey = vm.envUint("PRIVATE_KEY");
    Asslot challenge;

    event EmitFlag(address);

    function setUp() public {
        challenge = new Asslot();
    }

    function run() public {
        // Compiled bytecode from Solve.huff without constructor args... yet ;)
        bytes memory bytecode =
            hex"602060203803600039600051600055602c8060183d393df336610013573d3d60043d3d6000545af13d3df35b3d31316101c3620154b55a030460030360005260206000f3";
        bytes memory constructorArgs = abi.encode(address(challenge));
        bytes memory creationCode = bytes.concat(bytecode, constructorArgs);

        vm.expectEmit(false, false, false, true, address(challenge));
        emit EmitFlag(vm.addr(playerKey));

        address addr;
        vm.startBroadcast(playerKey);
        assembly {
            addr := create(0, add(creationCode, 0x20), mload(creationCode))
        }
        addr.call{gas: 100000}("");
        vm.stopBroadcast();
    }
}
