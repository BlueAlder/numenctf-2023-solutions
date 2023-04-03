pragma solidity ^0.8.17;

import "./asslot.sol";
import "forge-std/console.sol";

contract Solve {
    constructor(address challenge) {
        Asslot a = Asslot(challenge);
        a.f00000000_bvvvdlt();
    }

    fallback() external {
        console.log("gday");
    }
}
