// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title RoyaltyFlow Contract
/// @notice Automated creator royalty distribution system.
contract RoyaltyFlow {

    address[] public payees;
    mapping(address => uint256) public shares;
    uint256 public totalShares;
    
    constructor(address[] memory _payees, uint256[] memory _shares) {
        require(_payees.length == _shares.length, "Length mismatch");
        for (uint256 i = 0; i < _payees.length; i++) {
            payees.push(_payees[i]);
            shares[_payees[i]] = _shares[i];
            totalShares += _shares[i];
        }
    }
    
    receive() external payable {
        for (uint256 i = 0; i < payees.length; i++) {
            address payee = payees[i];
            uint256 payment = (msg.value * shares[payee]) / totalShares;
            payable(payee).transfer(payment);
        }
    }

}
