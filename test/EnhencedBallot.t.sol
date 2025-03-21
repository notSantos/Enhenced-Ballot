// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {EnhencedBallot} from "../src/EnhencedBallot.sol";

contract EnhencedBallotTest is Test {
    EnhencedBallot public enhBallot;
    address initialOwner = address(this);

    function setUp() public {
        enhBallot = new EnhencedBallot(initialOwner, 10);
    }

    function test_increaseNumber() public {
        enhBallot.increaseNumber();
        assertEq(enhBallot.number(), 11);

        enhBallot.increaseNumber();
        assertEq(enhBallot.number(), 12);
    }

    function test_decreaseNumber() public {
        enhBallot.decreaseNumber();
        assertEq(enhBallot.number(), 9);

        enhBallot.decreaseNumber();
        enhBallot.decreaseNumber();
        enhBallot.decreaseNumber();
        assertEq(enhBallot.number(), 6);
    }
}
