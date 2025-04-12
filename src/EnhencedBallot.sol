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
        uint256 votesInFavor;
        uint256 votesAgainst;
        bool isActive;
    }

    mapping(uint256 ballotId => Proposal) public registry;
    mapping(uint256 ProposalId => mapping(address voter => bool))
        public hasVotedForProposalID;

    function vote(uint256 _proposalID, bool _voteValue) public {
        require(registry[_proposalID].isActive, "This proposal is closed");
        require(
            !hasVotedForProposalID[_proposalID][msg.sender],
            "Already voted for this proposal"
        );

        if (_voteValue) {
            registry[_proposalID].votesInFavor++;
        } else {
            registry[_proposalID].votesAgainst++;
        }

        hasVotedForProposalID[_proposalID][msg.sender] = true;
    }

    function closeProposal(uint256 _proposalID) public {
        require(
            registry[_proposalID].creator == msg.sender,
            "You need to be the creator to close a proposal"
        );
        require(
            registry[_proposalID].isActive == true,
            "Proposal Already Inactive"
        );
        registry[_proposalID].isActive = false;
    }

    function createNewProposal(string memory _name) public {
        registry[ballotsCounter] = Proposal({
            name: _name,
            creator: msg.sender,
            id: ballotsCounter,
            votesInFavor: 0,
            votesAgainst: 0,
            isActive: true
        });

        emit ProposalCreation(_name, msg.sender, ballotsCounter);

        ballotsCounter++;
    }
}
