// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {EnhencedBallot} from "../src/EnhencedBallot.sol";

contract EnhencedBallotScript is Script {
    EnhencedBallot public enhBallot;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        address deployer = msg.sender;

        enhBallot = new EnhencedBallot(deployer, 10);

        vm.stopBroadcast();
    }
}
