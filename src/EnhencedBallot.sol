// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract EnhencedBallot {
    uint256 ballotsCounter;

    struct SimpleBallot {
        string name;
        address creator;
        uint256 votes;
    }

    mapping(uint256 ballotId => SimpleBallot) public registry;

    function createNewBallot(string memory _name) public {
        registry[ballotsCounter] = SimpleBallot({
            name: _name,
            creator: msg.sender,
            votes: 0
        });
    }
}
