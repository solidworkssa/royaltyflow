// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "forge-std/Test.sol";
import "../src/RoyaltyFlow.sol";

contract RoyaltyFlowTest is Test {
    RoyaltyFlow public c;
    
    function setUp() public {
        c = new RoyaltyFlow();
    }

    function testDeployment() public {
        assertTrue(address(c) != address(0));
    }
}
