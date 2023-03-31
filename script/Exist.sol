pragma solidity ^0.6.12;

import "forge-std/Script.sol";

import "../src/exist/create2.sol";
import "../src/exist/solve.sol";

contract Exist is Script {
    address contractAddress = vm.envAddress("CONTRACT_ADDRESS");
    uint256 playerKey = vm.envUint("PRIVATE_KEY");

    Existing challengeContract;

    function setUp() public {
        challengeContract = new Existing();
    }

    function run() public {
        vm.startBroadcast(playerKey);
        Create2Deployer deployer = new Create2Deployer();
        uint256 salt = 0;
        while (true) {
            address add = deployer.getDeployAddress(address(challengeContract), bytes32(salt));
            if (isGoodAddress(add)) {
                break;
            }
            salt++;
        }

        address res = deployer.deploy(bytes32(salt), address(challengeContract));
        require(challengeContract.isSolved(), "Challenge Not Solved");
    }

    function isGoodAddress(address add) public view returns (bool) {
        bytes20 code = bytes20(uint160(0xffff));
        bytes20 feature = bytes20(bytes32("ZT")) >> 144;
        bytes20 you = bytes20(add);

        for (uint256 i = 0; i < 34; i++) {
            if (you & code == feature) {
                return true;
            }

            code <<= 4;
            feature <<= 4;
        }
        return false;
    }
}
