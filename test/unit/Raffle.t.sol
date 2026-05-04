
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {DeployRaffle} from "../../script/DeployRaffle.s.sol";
import {Raffle} from "../../src/Raffle.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {Vm} from "forge-std/Vm.sol"; 
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";
import {CodeConstants} from "script/HelperConfig.s.sol";

contract RaffleTest is CodeConstants, Test {
    
    Raffle public raffle;
    HelperConfig public helperConfig;


    uint256 entranceFee;
    uint256 interval;
    address vrfCoordinator;
    bytes32 gasLane;
    uint32  callBackGasLimit;
    uint256 subscriptionId;

    /// @notice Used this "makeAddr", to create a Fake-User usining foundry cheatcode (to make a test)
    address public PLAYER = makeAddr("player");
    uint256 public constant STARTING_PLAYER_BALANCE =  10 ether;

    event RaffleEntered(address indexed player);
    event WinnerPicked(address indexed winner);
    
    function setUp() external {
        DeployRaffle deployer = new DeployRaffle();
        (raffle, helperConfig) = deployer.deployContract();

        vm.deal(PLAYER, STARTING_PLAYER_BALANCE);

        // Geting the  Network Configuration (for all chain already configured on HelperConfig file)
        HelperConfig.NetworkConfig memory config =  helperConfig.getConfig(); 

        //  Assigning  Config Values to Local Variables
        entranceFee = config.entranceFee;
        interval = config.interval;
        vrfCoordinator = config.vrfCoordinator;
        gasLane = config.gasLane;
        callBackGasLimit = config.callBackGasLimit;
        subscriptionId = config.subscriptionId;

        // Giving the players some money, using the foundry cheatcode "vm.deal()"
        // vm.deal(PLAYER, STARTING_PLAYER_BALANCE);
    }


    /// @notice function testRaffleInitializesOpenState(), helps us comfirm first if my RaffleState is OPEN just as it is on the "constructor parsed value" works perfectly
    function testRaffleInitializesInOpenState() public view {
        assert(raffle.getRaffleState() == Raffle.RaffleState.OPEN);
    }


    /// @notice function testRaffleRevertsWhenYouDontPayEnough() , that test if the "msg.value" is not upto the entranceFee" , then revert
    function testRaffleRevertsWhenYouDontPayEnough() public {
        //  Arrange 
        vm.prank(PLAYER);

        // Act / Assert
        vm.expectRevert(Raffle.Raffle__SendMoreEThToEnterRaffle.selector);
        raffle.enterRaffle();  
    } 


    /// @notice Function testRecordPlayersWhenTheyEnter() , test the raffle actually updates
    function testRecordPlayersWhenTheyEnter() public {
        // Arrange 
        vm.prank(PLAYER);

        // Act
         raffle.enterRaffle{value: entranceFee}();

        // Assert
        address playerRecorded =  raffle.getPlayer(0);

        assert(playerRecorded == PLAYER); // Condition check To make it the correct player that is added
    }

    /// @notice function testEnteringRaffleEmitsEvent() , for testing Raffle Entrting Raffle Event 
    function testEnteringRaffleEmitsEvent() public {
        // Arrange
        vm.prank(PLAYER);

        // Act
        vm.expectEmit(true, false, false, false, address(raffle));
         emit RaffleEntered(PLAYER);

        // Assert
        raffle.enterRaffle{value: entranceFee}(); 
    }


    /// @notice function testDontAllowPlayersToEnterWhileRaffleIsCalculating() test
    function testDontAllowPlayersToEnterWhileRaffleIsCalculating() public {
        // ARRANGE
        vm.prank(PLAYER);
        raffle.enterRaffle{value: entranceFee}();
        vm.warp(block.timestamp + interval + 1);
        vm.roll(block.number + 1);
        raffle.performUpkeep("");

        // ASSERT / ACT
        vm.expectRevert(Raffle.Raffle__RaffleNotOpen.selector);

        vm.prank(PLAYER);
        raffle.enterRaffle{value: entranceFee}();
    }



    /*//////////////////////////////////////////////////////////////
                              CHECKUPKEEP 
    //////////////////////////////////////////////////////////////*/


    /// @notice Checks that checkUpkeep returns false if the raffle has no ETH balance
    /// @dev Even if time has passed, upkeep should not be needed if the contract is empty
    function checkUpKeepReturnsFalseIfItHasNoBalance() public {
       // ARRANGE
        vm.warp(block.timestamp + interval + 1);
        vm.roll(block.number + 1);

       // ACT
       (bool upKeepNeeded,) = raffle.checkUpkeep("");

       // ASSERT
       assert(!upKeepNeeded); 
    }


    
    /// @notice Tests that checkUpkeep returns false when the raffle state is not OPEN (e.g., CALCULATING).
    function testCheckUpkeepReturnsFalseIfRaffleIsNotOpen() public {
        //ARRANGE
        vm.prank(PLAYER);
        raffle.enterRaffle{value: entranceFee}();
        vm.warp(block.timestamp + interval + 1);
        vm.roll(block.number + 1);
        raffle.performUpkeep("");  

        //ASSERT
        (bool upKeepNeeded,) = raffle.checkUpkeep("");

        // ASSERT
        assert(!upKeepNeeded);
    }


    /// @notice testCheckUpKeepReturnsFalseIfEnoughTimeHasPassed() Tests that checkUpkeep returns true when the raffle is OPEN and enough time has passed.
    function testCheckUpKeepReturnsFalseIfEnoughTimeHasPassed() public {
        vm.prank(PLAYER);
        raffle.enterRaffle{value: entranceFee}();

        // vm.warp(block.timestamp + 1 days);
        vm.warp(block.timestamp + interval + 1 );
        vm.roll(block.number + 1);

           // ACT
        (bool upKeepNeeded,) = raffle.checkUpkeep("");

            // ASSERT
        assert(upKeepNeeded);  
    }


    /// @notice testCheckUpKeepReturnsFalseIfEnoughTimeHasNotPassed() Function, Tests that checkUpkeep returns false if the required time interval has not passed since the last upkeep....   
    function testCheckUpKeepReturnsFalseIfEnoughTimeHasNotPassed() public {
        // ARRANGE
        vm.prank(PLAYER);
        raffle.enterRaffle{value: entranceFee}();

           // ACT
        (bool upKeepNeeded,) = raffle.checkUpkeep("");

            // ASSERT
        assert(!upKeepNeeded);
    }


    function testCheckUpKeepReturnsTrueWhenParametersAreGood() public {
         // ARRANGE 
        vm.prank(PLAYER);
        raffle.enterRaffle{value: entranceFee}(); 
        vm.warp(block.timestamp + interval + 1 );  
        vm.roll(block.number + 1);   
           
        // ACT
        (bool upKeepNeeded, ) = raffle.checkUpkeep("");  

         // ASSERT
        assert(upKeepNeeded);
    }



    /*//////////////////////////////////////////////////////////////
                             PERFORM UPKEEP
    //////////////////////////////////////////////////////////////*/
    function testPerformUpKeepCanOnlyRunIfCheckUpKeepIsTrue() public {
        // ARRANGE
        vm.prank(PLAYER);
        raffle.enterRaffle{value: entranceFee}(); 
        vm.warp(block.timestamp + interval + 1 );  
        vm.roll(block.number + 1);  

        // ACT / ASSERT
        raffle.performUpkeep("");
        
    } 

    
    /// @notice  function testPerformUpkeepRevertsIfCheckUpkeepIsFalse() , Ensures performUpkeep reverts if checkUpkeep is false (e.g., no players or balance)
    function testPerformUpkeepRevertsIfCheckUpkeepIsFalse() public {
        // ARRANGE
        uint256 currentBalance = 0; 
        uint256 numPlayers = 0; 
        Raffle.RaffleState rState = raffle.getRaffleState();

        vm.prank(PLAYER);
        raffle.enterRaffle{value: entranceFee}();
        currentBalance = currentBalance + entranceFee;
        numPlayers = 1;

        // ACT  / ASSERT
        vm.expectRevert(
             abi.encodeWithSelector(Raffle.Raffle__UpKeepNotNeeded.selector, currentBalance, numPlayers, rState)
        );
        raffle.performUpkeep("");
    }


    modifier raffleEntered { 
            //ARRANGE
        vm.prank(PLAYER); 
        raffle.enterRaffle{value: entranceFee}();
        vm.warp(block.timestamp + interval + 1); 
        vm.roll(block.number + 1); 
        _;
    }


    /// @notice Tests that performUpkeep updates the raffle state to CALCULATING
    /// and emits a valid requestId from the Chainlink VRF.
    function testPerformUpkeepUpdatesRaffleStateAndEmitsRequestId() public raffleEntered {
       
        // ACT
        vm.recordLogs(); 
        raffle.performUpkeep("");
        Vm.Log[] memory entries = vm.getRecordedLogs(); 
        bytes32 requestId = entries[1].topics[1];

        // ASSERT
        Raffle.RaffleState raffleState = raffle.getRaffleState();
        assert(uint256(requestId) > 0);  
        assert(uint256(raffleState) == 1); 
    }




      /*//////////////////////////////////////////////////////////////
                           FULFILLRANDOMWORDS
    //////////////////////////////////////////////////////////////*/
    
    modifier skipFork() {
        if(block.chainid != LOCAL_CHAIN_ID){
            return;
        }
        _;
    }

    function testFulfillrandomWordsShouldAndCanOnlyBeCalledAfterPerformUpkeepHasBeenCalled(uint256 randomRequestId) public raffleEntered skipFork {
        // ARRANGE  / ACT / ASSERT
        vm.expectRevert(VRFCoordinatorV2_5Mock.InvalidRequest.selector);
        VRFCoordinatorV2_5Mock(vrfCoordinator).fulfillRandomWords(randomRequestId, address(raffle));
    }


    function testFulfillrandomWordsPicksWinnerResetsAndSendsMoney() public raffleEntered skipFork {
            // ARRANGE
        uint256 additionalEntrace = 3; 
        uint256 startingIndex = 1;
        address expectedWinner = address(1);
        

        for (uint256 i = startingIndex; i < startingIndex + additionalEntrace; i++) {
            address newPlayer = address(uint160(i));
            hoax(newPlayer, 1 ether); 
            raffle.enterRaffle{value: entranceFee}();
        }
        uint256 startingTimeStamp = raffle.getLastTimeStamp();
        uint256 winnerStartingBalance = expectedWinner.balance;

            
            //ACT
        vm.recordLogs();    
        raffle.performUpkeep(""); 
        Vm.Log[] memory entries = vm.getRecordedLogs();  
        bytes32 requestId = entries[1].topics[1];

        VRFCoordinatorV2_5Mock(vrfCoordinator).fulfillRandomWords(uint256(requestId), address(raffle));

            // ASSERT
        address recentWinner = raffle.getRecentWinner();
        Raffle.RaffleState raffleState = raffle.getRaffleState();
        uint256 winnerBalance = recentWinner.balance;
        uint256 endingTimeStamp = raffle.getLastTimeStamp();
        uint256 prize = entranceFee * (additionalEntrace + 1);

        assert(recentWinner == expectedWinner);
        assert(uint256(raffleState) == 0);
        assert(winnerBalance == winnerStartingBalance + prize); 
        assert(endingTimeStamp > startingTimeStamp);
    }
   





}

