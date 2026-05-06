// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {Raffle} from "../../src/Raffle.sol";
import {DeployRaffle} from "../../script/DeployRaffle.s.sol";
import {CreateSubscription, FundSubscription, AddConsumer} from "../../script/Interactions.s.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";


contract IntegrationTest is Test {
        // State Variables
    Raffle raffle;
    HelperConfig public helperConfig; 

    address public PLAYER = makeAddr("player"); 
    uint256 public constant STARTING_PLAYER_BALANCE =  1 ether;


        // Functions
    function setUp() public {
        DeployRaffle deployRaffle = new DeployRaffle();
        (raffle, helperConfig ) = deployRaffle.deployContract(); 

        vm.deal(PLAYER, STARTING_PLAYER_BALANCE);
    }


    /// @dev Validates that a player can successfully enter the raffle when it is in an OPEN state and their address is recorded. 
    function testUserCanEnterRaffleWhenOpen() public {
            // Arrange
        uint256 entranceFee = raffle.getEntranceFee();

            // Act
        vm.prank(PLAYER);
        raffle.enterRaffle{value: entranceFee}();

            // Assert
        address playerRecorded =  raffle.getPlayer(0);
        assert(playerRecorded == PLAYER);
    }


    /// @notice  Tests the CreateSubscription script to ensure it creates a valid subscription.
    function testCreateSubscriptionScriptWorks() public {
        // Arrange / Act
        CreateSubscription createSub = new CreateSubscription();

        (uint256 subId, address vrfCoordinator) = createSub.createSubscriptionUsingConfig();

        // Assert
        assert(subId > 0);
        assert(vrfCoordinator != address(0));
    } 

   
    
}


























