// SPDX-License-Identifier: MIT
pragma solidity ^0.5.10;

contract TechneoUSDT {
    string public name = "TechneoUSDT";
    string public symbol = "USDT";
    uint8 public decimals = 6;
    uint256 public totalSupply;

    address public owner;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not contract owner");
        _;
    }

    constructor() public {
        owner = msg.sender;
        totalSupply = 1000000000000 * 10 ** uint256(decimals); // 1 trillion tokens
        balanceOf[owner] = totalSupply;
        emit Transfer(address(0), owner, totalSupply);
    }

    function transfer(address to, uint256 value) public returns (bool success) {
        require(balanceOf[msg.sender] >= value, "Insufficient balance");
        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool success) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool success) {
        require(balanceOf[from] >= value, "Insufficient balance");
        require(allowance[from][msg.sender] >= value, "Allowance exceeded");
        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;
        emit Transfer(from, to, value);
        return true;
    }

    function mint(uint256 amount) public onlyOwner {
        uint256 mintedAmount = amount * 10 ** uint256(decimals);
        totalSupply += mintedAmount;
        balanceOf[owner] += mintedAmount;
        emit Transfer(address(0), owner, mintedAmount);
    }

    function burn(uint256 amount) public onlyOwner {
        uint256 burnedAmount = amount * 10 ** uint256(decimals);
        require(balanceOf[owner] >= burnedAmount, "Insufficient balance to burn");
        totalSupply -= burnedAmount;
        balanceOf[owner] -= burnedAmount;
        emit Transfer(owner, address(0), burnedAmount);
    }
}