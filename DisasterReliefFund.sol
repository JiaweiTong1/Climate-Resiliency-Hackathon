// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DisasterReliefFund {
    
    // Owner of the contract (usually a government body or verified NGO)
    address public owner;
    
    // Donation details with donor, beneficiary, amount, and timestamp
    struct Donation {
        address donor;
        address beneficiary;
        uint256 amount;
        uint256 timestamp;
    }
    
    // Beneficiary details
    struct Beneficiary {
        address beneficiaryAddress;
        uint256 totalWithdrawn;
        uint256 totalReceived;
    }
    
    // Donation tracking
    Donation[] public donations;
    
    // Mapping to keep track of approved beneficiaries
    mapping(address => Beneficiary) public beneficiaries;
    
    // Events for transparency
    event DonationReceived(address indexed donor, address indexed beneficiary, uint256 amount, uint256 timestamp);
    event BeneficiaryAdded(address indexed beneficiaryAddress);
    event FundsWithdrawn(address indexed beneficiary, uint256 amount, uint256 timestamp);
    
    // Constructor to set contract owner
    constructor() {
        owner = msg.sender;
    }

    // Modifier to restrict access to only the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can perform this action.");
        _;
    }

    // Modifier to restrict access to approved beneficiaries only
    modifier onlyBeneficiary() {
        require(beneficiaries[msg.sender].beneficiaryAddress == msg.sender, "Only approved beneficiaries can withdraw funds.");
        _;
    }

    // Donate to a specific beneficiary
    function donate(address _beneficiary) external payable {
        require(msg.value > 0, "Donation must be greater than 0");
        require(beneficiaries[_beneficiary].beneficiaryAddress == _beneficiary, "Beneficiary must be approved");

        // Record the donation with donor, beneficiary, amount, and timestamp
        donations.push(Donation({
            donor: msg.sender,
            beneficiary: _beneficiary,
            amount: msg.value,
            timestamp: block.timestamp
        }));

        // 增加受益者的总金额
        beneficiaries[_beneficiary].totalReceived += msg.value;

        // Emit the donation event for transparency
        emit DonationReceived(msg.sender, _beneficiary, msg.value, block.timestamp);
    }

    // Get total donations received
    function totalDonations() public view returns (uint256) {
        return address(this).balance;
    }

    // Owner adds a beneficiary who can receive donations and withdraw funds
    function addBeneficiary(address _beneficiaryAddress) external onlyOwner {
        require(_beneficiaryAddress != address(0), "Invalid address for beneficiary.");
        
        // Register the new beneficiary
        beneficiaries[_beneficiaryAddress] = Beneficiary({
            beneficiaryAddress: _beneficiaryAddress,
            totalWithdrawn: 0,
            totalReceived: 0 // 初始化时设置为0
        });
        
        // Emit the beneficiary added event
        emit BeneficiaryAdded(_beneficiaryAddress);
    }

    // Beneficiary withdraws a specified amount
    function withdrawFunds(uint256 _amount) external onlyBeneficiary {
        require(_amount > 0, "Withdraw amount must be greater than 0.");
        require(_amount <= beneficiaries[msg.sender].totalReceived - beneficiaries[msg.sender].totalWithdrawn, "Insufficient funds in the beneficiary's account.");

        // Update beneficiary's total withdrawn amount
        beneficiaries[msg.sender].totalWithdrawn += _amount;

        // Transfer funds to the beneficiary
        payable(msg.sender).transfer(_amount);
        
        // Emit the withdrawal event for transparency
        emit FundsWithdrawn(msg.sender, _amount, block.timestamp);
    }

    // View total amount received by a specific beneficiary
    function totalReceivedBy(address _beneficiaryAddress) public view returns (uint256) {
        return beneficiaries[_beneficiaryAddress].totalReceived;
    }

    // View total amount withdrawn by a specific beneficiary
    function totalWithdrawnBy(address _beneficiaryAddress) public view returns (uint256) {
        return beneficiaries[_beneficiaryAddress].totalWithdrawn;
    }

    // View all donations for transparency (returns an array of donations)
    function getAllDonations() public view returns (Donation[] memory) {
        return donations;
    }
}
