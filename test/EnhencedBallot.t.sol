// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {EnhencedBallot} from "../src/EnhencedBallot.sol";

contract EnhencedBallotTest is Test {
    EnhencedBallot public enhencedBallot;
    address owner = msg.sender;
    address user1 = address(0x1);
    address user2 = address(0x2);

    // runs before each test is run
    function setUp() public {
        enhencedBallot = new EnhencedBallot();
    }

    function test_createSimpleBallot() public {}
}
