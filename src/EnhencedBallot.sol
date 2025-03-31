// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract EnhencedBallot {
    uint256 public ballotsCounter;

    event ProposalCreation(
        string indexed _proposalName,
        address _creator,
        uint256 _id
    );

    struct Proposal {
        string name;
        address creator;
        uint256 id;
        uint256 votes;
    }

    mapping(uint256 ballotId => Proposal) public registry;
    mapping(uint256 ProposalId => mapping(address voter => bool))
        public hasVotedForProposalID;

    function vote(uint256 _proposalID) public {
        require(
            !hasVotedForProposalID[_proposalID][msg.sender],
            "Already voted for this proposal"
        );

        registry[_proposalID].votes++;
        hasVotedForProposalID[_proposalID][msg.sender] = true;
    }

    function createNewProposal(string memory _name) public {
        registry[ballotsCounter] = Proposal({
            name: _name,
            creator: msg.sender,
            id: ballotsCounter,
            votes: 0
        });

        emit ProposalCreation(_name, msg.sender, ballotsCounter);

        ballotsCounter++;
    }
}
