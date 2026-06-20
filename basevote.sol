// SPDX-License-Identifier: MIT
pragma solidity 0.8.34;

contract BaseVoting {
    address public owner;
    string public contractVersion = "4.2.0"; // متمایزکننده بایت‌کد
    
    string public proposalDescription = "Should we build a decentralized future on Base?";
    uint256 public votesForYes;
    uint256 public votesForNo;
    
    mapping(address => bool) public hasVoted;

    event VoteCast(address indexed voter, bool vote);

    constructor() {
        owner = msg.sender;
    }

    // تابع رای دادن (ورودی true یعنی بله، ورودی false یعنی خیر)
    function castVote(bool _vote) public {
        require(!hasVoted[msg.sender], "You have already voted");
        
        hasVoted[msg.sender] = true;
        
        if (_vote) {
            votesForYes++;
        } else {
            votesForNo++;
        }
        
        emit VoteCast(msg.sender, _vote);
    }

    // مشاهده نتیجه کلی رای‌گیری
    function getResults() public view returns (uint256 yesVotes, uint256 noVotes) {
        return (votesForYes, votesForNo);
    }
}