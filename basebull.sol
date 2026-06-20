// SPDX-License-Identifier: MIT
pragma solidity 0.8.34;

contract BaseLuckyDraw {
    address public owner;
    address[] public players;
    string public contractVersion = "3.1.0"; // متمایزکننده بایت‌کد

    event PlayerEntered(address indexed player, uint256 amount);
    event WinnerPicked(address indexed winner, uint256 prizePool);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // ورود به قرعه‌کشی با فرستادن اتریوم (مثلاً حداقل 0.0001 اتریوم)
    function enter() public payable {
        require(msg.value >= 0.0001 ether, "Minimum ETH required to enter");
        players.push(msg.sender);
        emit PlayerEntered(msg.sender, msg.value);
    }

    // انتخاب برنده (فقط توسط مالک)
    function pickWinner() public onlyOwner {
        require(players.length > 0, "No players in the lottery");
        
        // ایجاد یک عدد شبه‌تصادفی ساده بر اساس بلاکچین
        uint256 index = uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, players))) % players.length;
        address winner = players[index];
        
        uint256 prizePool = address(this).balance;
        
        // واریز کل موجودی به حساب برنده
        (bool success, ) = payable(winner).call{value: prizePool}("");
        require(success, "Transfer to winner failed");
        
        emit WinnerPicked(winner, prizePool);
        
        // ریست کردن لیست بازیکنان برای قرعه‌کشی بعدی
        players = new address[](0);
    }

    // مشاهده لیست شرکت‌کنندگان
    function getPlayers() public view returns (address[] memory) {
        return players;
    }
}