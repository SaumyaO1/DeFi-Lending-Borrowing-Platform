// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract LendingBorrowing {
    struct Loan {
        address borrower;
        uint256 amount;
        uint256 collateral;
        bool isRepaid;
    }

    mapping(address => uint256) public collaterals;
    mapping(address => Loan) public loans;

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function depositCollateral() external payable {
        require(msg.value > 0, "Collateral must be greater than 0");
        collaterals[msg.sender] += msg.value;
    }

    function requestLoan(uint256 _amount) external {
        require(collaterals[msg.sender] >= _amount / 2, "Insufficient collateral");
        require(loans[msg.sender].amount == 0, "Existing loan");

        loans[msg.sender] = Loan({
            borrower: msg.sender,
            amount: _amount,
            collateral: collaterals[msg.sender],
            isRepaid: false
        });

        payable(msg.sender).transfer(_amount);
    }

    function repayLoan() external payable {
        Loan storage loan = loans[msg.sender];
        require(loan.amount > 0 && !loan.isRepaid, "No active loan");
        require(msg.value >= loan.amount, "Insufficient repayment");

        loan.isRepaid = true;
        collaterals[msg.sender] = 0;
    }

    function withdrawCollateral() external {
        require(loans[msg.sender].isRepaid, "Loan not repaid");
        uint256 amount = collaterals[msg.sender];
        require(amount > 0, "No collateral");

        collaterals[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }
}
