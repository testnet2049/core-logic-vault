// SPDX-License-Identifier: MIT
pragma solidity 0.8.34;

contract BaseGuestbookV2 {
    struct Message {
        address sender;
        string text;
        uint256 timestamp;
    }

    // تغییر در ساختار برای متمایز شدن بایت‌کد در بیس‌اسکن
    string public contractVersion = "2.0.0"; 
    Message[] public messages;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function writeMessage(string calldata _text) public payable {
        messages.push(Message({
            sender: msg.sender,
            text: _text,
            timestamp: block.timestamp
        }));
    }

    function getMessages() public view returns (Message[] memory) {
        return messages;
    }

    function withdraw() public {
        require(msg.sender == owner, "Only owner");
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");
        
        (bool success, ) = payable(owner).call{value: balance}("");
        require(success, "Transfer failed");
    }
}