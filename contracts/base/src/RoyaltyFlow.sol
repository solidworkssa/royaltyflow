// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract RoyaltyFlow {
    struct Split {
        address[] recipients;
        uint256[] percentages;
        uint256 totalReceived;
        bool active;
    }

    mapping(uint256 => Split) public splits;
    uint256 public splitCounter;

    event SplitCreated(uint256 indexed splitId, address[] recipients);
    event PaymentDistributed(uint256 indexed splitId, uint256 amount);

    error InvalidSplit();
    error TransferFailed();

    function createSplit(address[] memory recipients, uint256[] memory percentages) external returns (uint256) {
        if (recipients.length != percentages.length) revert InvalidSplit();
        uint256 total = 0;
        for (uint256 i = 0; i < percentages.length; i++) {
            total += percentages[i];
        }
        if (total != 10000) revert InvalidSplit();

        uint256 splitId = splitCounter++;
        splits[splitId].recipients = recipients;
        splits[splitId].percentages = percentages;
        splits[splitId].active = true;
        emit SplitCreated(splitId, recipients);
        return splitId;
    }

    function distributePayment(uint256 splitId) external payable {
        Split storage split = splits[splitId];
        if (!split.active) revert InvalidSplit();

        for (uint256 i = 0; i < split.recipients.length; i++) {
            uint256 amount = (msg.value * split.percentages[i]) / 10000;
            (bool success, ) = split.recipients[i].call{value: amount}("");
            if (!success) revert TransferFailed();
        }

        split.totalReceived += msg.value;
        emit PaymentDistributed(splitId, msg.value);
    }

    function getSplit(uint256 splitId) external view returns (address[] memory, uint256[] memory) {
        return (splits[splitId].recipients, splits[splitId].percentages);
    }
}
