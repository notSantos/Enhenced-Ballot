// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {EnhencedBallot} from "../src/EnhencedBallot.sol";

contract EnhencedBallotTest is Test {
    EnhencedBallot public enhencedBallot;

    event ProposalCreation(
        string indexed _proposalName,
        address _creator,
        uint256 _id
    );

    address owner = msg.sender;
    address user1 = address(0x1);
    address user2 = address(0x2);
    address user3 = address(0x3);
    address user4 = address(0x4);
    address user5 = address(0x5);

    // runs before each test is run
    function setUp() public {
        enhencedBallot = new EnhencedBallot();

        string memory baseProposalName = "Base Proposal";
        enhencedBallot.createNewProposal(baseProposalName);
    }

    function test_createProposal() public {
        address functionCaller = address(msg.sender);
        vm.prank(functionCaller);

        uint256 previousBallotCounter = enhencedBallot.ballotsCounter();
        assert(previousBallotCounter == 1);

        vm.prank(functionCaller);
        string memory testProposalName = "Hard Fork";

        // Check first, second and not third topics (indexed data)
        // Last argument is for checking non indexed data
        vm.expectEmit(true, true, false, false);
        emit ProposalCreation(testProposalName, functionCaller, 1);
        enhencedBallot.createNewProposal(testProposalName);

        (
            string memory implemented_name,
            address proposal_creator,
            uint256 id,
            uint256 initial_vote_count
        ) = enhencedBallot.registry(1);

        bytes32 fmtedStructName = keccak256(bytes(implemented_name));
        bytes32 fmtedLocalName = keccak256(bytes(testProposalName));
        assertEq(fmtedStructName, fmtedLocalName);
        assertEq(id, 1);
        assert(proposal_creator == functionCaller);
        assert(initial_vote_count == 0);

        uint256 postBallotCounter = enhencedBallot.ballotsCounter();
        assert(postBallotCounter == 2);
    }

    function test_voteForProposal() public {
        string memory testProposalName = "";
        vm.prank(owner);

        enhencedBallot.createNewProposal(testProposalName);
        (, , uint256 id, uint256 initial_count) = enhencedBallot.registry(0);

        assertEq(initial_count, 0);
        assertEq(id, 0);

        vm.prank(user1);
        enhencedBallot.vote(0);
        (, , , uint256 vote_count1) = enhencedBallot.registry(0);

        assertEq(vote_count1, 1);

        vm.prank(user2);
        enhencedBallot.vote(0);
        (, , , uint256 vote_count2) = enhencedBallot.registry(0);
        assertEq(vote_count2, 2);
    }

    function test_registerUserVoting() public {
        // Testing for user 2 and 3 to be registered as false for voting before voting
        bool hasUser2Voted = enhencedBallot.hasVotedForProposalID(0, user2);
        assert(hasUser2Voted == false);

        bool hasUser3Voted = enhencedBallot.hasVotedForProposalID(0, user3);
        assert(hasUser3Voted == false);

        // Testing for only user 2 to change its status
        vm.prank(user2);
        enhencedBallot.vote(0);

        bool hasVotedForBaseProposal = enhencedBallot.hasVotedForProposalID(
            0,
            user2
        );

        bool hasUser3votedAfter = enhencedBallot.hasVotedForProposalID(
            0,
            user3
        );

        // Only user 2 should change its status
        assert(hasUser3votedAfter == false);
        assert(hasVotedForBaseProposal == true);
    }

    function test_Revert_WhenVotingForTheSameProposalTwice() public {
        // User 2 can vote
        vm.prank(user2);
        enhencedBallot.vote(0);

        vm.prank(user2);
        vm.expectRevert(bytes("Already voted for this proposal"));
        enhencedBallot.vote(0);

        // User 3 can vote normally, even when User 2 can't
        vm.prank(user3);
        enhencedBallot.vote(0);
    }
}
