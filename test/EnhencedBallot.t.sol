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

    // runs before each test is run
    function setUp() public {
        enhencedBallot = new EnhencedBallot();
    }

    function test_create_proposal() public {
        address functionCaller = address(msg.sender);
        vm.prank(functionCaller);

        uint256 previousBallotCounter = enhencedBallot.ballotsCounter();
        assert(previousBallotCounter == 0);

        vm.prank(functionCaller);
        string memory testProposalName = "Hard Fork";

        // Check first, second and not third topics (indexed data)
        // Last argument is for checking non indexed data
        vm.expectEmit(true, true, false, false);
        emit ProposalCreation(testProposalName, functionCaller, 0);
        enhencedBallot.createNewProposal(testProposalName);

        (
            string memory implemented_name,
            address proposal_creator,
            uint256 id,
            uint256 initial_vote_count
        ) = enhencedBallot.registry(0);

        bytes32 fmtedStructName = keccak256(bytes(implemented_name));
        bytes32 fmtedLocalName = keccak256(bytes(testProposalName));
        assertEq(fmtedStructName, fmtedLocalName);

        assert(proposal_creator == functionCaller);
        assert(initial_vote_count == 0);

        uint256 postBallotCounter = enhencedBallot.ballotsCounter();
        assert(postBallotCounter == 1);
    }

    function test_createSimpleBallot() public {}
}
