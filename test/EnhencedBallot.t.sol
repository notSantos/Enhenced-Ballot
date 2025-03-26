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
    function test_create_proposal() public {
        uint256 previousBallotCounter = enhencedBallot.ballotsCounter();
        assert(previousBallotCounter == 0);

        string memory testProposalName = "Hard Fork";
        enhencedBallot.createNewProposal(testProposalName);

        (
            string memory implemented_name,
            address proposal_creator,
            uint256 initial_vote_count
        ) = enhencedBallot.registry(0);

        // assert(implemented_name == testProposalName);
        assert(proposal_creator == msg.sender);
        assert(initial_vote_count == 0);

        uint256 postBallotCounter = enhencedBallot.ballotsCounter();
        assert(postBallotCounter == 1);
    }

    function test_createSimpleBallot() public {}
}
