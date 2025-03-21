// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract EnhencedBallot is Ownable {
    struct Voter {
        bool hasVoted;
    }

    struct Proposal {
        string proposalName;
        uint256 voteCount;
        address creator;
    }

    mapping(address => bool) public hasUserVoted;
    Proposal public proposal;

    constructor(address initialOwner) Ownable(initialOwner) {}

    function CreateProposal(string memory _proposalName) public onlyOwner {
        proposal = Proposal({
            proposalName: _proposalName,
            voteCount: 0,
            creator: msg.sender
        });
    }
}
