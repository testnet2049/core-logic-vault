// SPDX-License-Identifier: MIT
pragma solidity 0.8.34;

contract BaseVault {
    address public owner;

    event Deposited(address indexed sender, uint256 amount);
    event Withdrawn(uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // برای دریافت اتریوم بدون صدا زدن تابع خاصی
    receive() external payable {
        if (msg.value > 0) {
            emit Deposited(msg.sender, msg.value);
        }
    }

    // تابع واریز مستقیم
    function deposit() public payable {
        require(msg.value > 0, "Send some ETH");
        emit Deposited(msg.sender, msg.value);
    }

    // تابع برداشت کل موجودی فقط توسط مالک
    function withdrawAll() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "Vault is empty");
        
        (bool success, ) = payable(owner).call{value: balance}("");
        require(success, "Transfer failed");
        
        emit Withdrawn(balance);
    }

    // مشاهده موجودی صندوق
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}