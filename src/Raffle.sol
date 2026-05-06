

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";

// import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/dev/vrf/libraries/VRFV2PlusClient.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";
import {console} from "forge-std/console.sol";

/**
 * @title  A Sample Raffle Contract
 * @author  LegendaryCode
 * @notice  This contract is for creating a sample raffle
 * @dev     Implements Chainlink  VRFv2.5
 */

contract Raffle is VRFConsumerBaseV2Plus {
   
    /*** Errors */
    error Raffle__SendMoreEThToEnterRaffle();
    error Raffle__TransferFailed();
    error Raffle__RaffleNotOpen();
    error Raffle__UpKeepNotNeeded(uint256 balance, uint256 playersLength, uint256 raffleState);


    /** Type Declarations */
    enum RaffleState {
        OPEN,      // 0
        CALCULATING  // 1
    }



    /** State Variables */
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDS = 1;
    uint256 private immutable i_entranceFee;
    uint256 private immutable i_interval;
    bytes32 private immutable i_keyHash;
    uint256 private immutable i_subscriptionId;
    uint32 private immutable i_callbackGasLimit;
    address payable[] private s_players;

    /// @dev The duration of the lottery in seconds.
    uint256 private s_lastTimeStamp;

    address private s_recentWinner;

    /// @notice The lottery will start as OPEN
    RaffleState private s_raffleState;  


    /** Events */
    event RaffleEntered(address indexed player);
    event WinnerPicked(address indexed winner);
    event RequestedRaffleWinner(uint256 indexed requestId);


    /// @notice The "constructor" runs once when the contract is deployed. It sets up the initial states.
    constructor(
        uint256 entranceFee,
        uint256 interval,
        address vrfCoordinator,
        bytes32 gasLane,
        uint256 subscriptionId,
        uint32 callbackGasLimit
    ) VRFConsumerBaseV2Plus(vrfCoordinator) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        i_keyHash = gasLane;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;

        s_lastTimeStamp = block.timestamp; /// @notice Initial Timestamp
        s_raffleState = RaffleState.OPEN; /// @notice Initial Raffle State
    }



    /** Functions */
    function enterRaffle() external payable {
        

        if (msg.value < i_entranceFee) {
            revert Raffle__SendMoreEThToEnterRaffle();
        }

        if(s_raffleState != RaffleState.OPEN){
            revert Raffle__RaffleNotOpen();
        }

        s_players.push(payable(msg.sender));
        emit RaffleEntered(msg.sender);
    }

   /// @notice When should the winner be picked ?
   /**
    * @dev This is the function that the chainlink nodes will call to see
     * if the lottery is ready to have a winner picked.
     * The following should be true in order for upKeepNeeded to be true.
     * 1. The time interval has passed between raffle runs.
     * 2. The lottery is open.
     * 3. The contract has ETH.
     * 4. Your subscription has LINK.
    * @param - ignored 
    * @return upkeepNeeded - true if it's time to restart the lottery.
    * @return - ignored
    */

    function checkUpkeep(bytes memory /* checkData */) 
        public view 
        returns(bool upkeepNeeded, bytes memory /* performData */)
    {
        bool timeHasPassed =  ((block.timestamp - s_lastTimeStamp) >=  i_interval);
        bool isOpen =  s_raffleState == RaffleState.OPEN;
        bool hasBalance = address(this).balance > 0;
        bool hasPlayers = s_players.length > 0;
        upkeepNeeded = timeHasPassed && isOpen && hasBalance && hasPlayers;
        return (upkeepNeeded, "");
    }


    /// @notice perform() function 3. Be able to do this all time , automatically.
    function performUpkeep(bytes calldata /* performData */) 
        external 
    {
        (bool upkeepNeeded,) =  checkUpkeep("");
        if(!upkeepNeeded){
           revert Raffle__UpKeepNotNeeded(address(this).balance, s_players.length, uint256(s_raffleState));
        }

       

        //s_raffleState = RaffleState.CALCULATING; THIS IS TO PREVENT ANYONE FROM ENTERING THE RAFFLE WHILE WE ARE CALCULATING THE WINNER
        s_raffleState = RaffleState.CALCULATING;
        VRFV2PlusClient.RandomWordsRequest memory request = VRFV2PlusClient.RandomWordsRequest({
            keyHash: i_keyHash,
            subId: i_subscriptionId,
            requestConfirmations: REQUEST_CONFIRMATIONS,
            callbackGasLimit: i_callbackGasLimit,
            numWords: NUM_WORDS,
            extraArgs: VRFV2PlusClient._argsToBytes(
                // Set nativePayment to true to pay for VRF requests with Sepolia ETH instead of LINK
                VRFV2PlusClient.ExtraArgsV1({nativePayment: false})
            )
        });
        uint256 requestId = s_vrfCoordinator.requestRandomWords(request);
        emit RequestedRaffleWinner(requestId);
    }


    function fulfillRandomWords(uint256 /*requestId*/, uint256[] calldata randomWords) internal override {
        // CHECKS (Validate the inputs and conditions to ensure that the function can execute successfully)

        
        // Effect (Updating the state of the contract) - Internal Contract State
        uint256 indexOfWinner = randomWords[0] % s_players.length;
        address payable recentWinner = s_players[indexOfWinner];
        s_recentWinner = recentWinner;

        s_raffleState = RaffleState.OPEN;
        s_players = new address payable[](0);
        s_lastTimeStamp = block.timestamp;

        emit WinnerPicked(s_recentWinner);
        
        // Interactions (External Contract Interactions)
        (bool success, ) = recentWinner.call{value: address(this).balance}("");
        if(!success) {
            revert Raffle__TransferFailed();
        }
    }

    /// @notice Getter function for i_entranceFee (since it made private)
    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }

    /// @notice Getter function for RaffleState (since it made private)
    function getRaffleState() external view returns (RaffleState ) {
        return s_raffleState;
    }

    /// @notice Getter function for getPlayers Array. To be able to get players
    function getPlayer(uint256 indexOfPlayer) external view returns(address) {
        return s_players[indexOfPlayer];
    }

    function getLastTimeStamp() external view returns(uint256){
        return s_lastTimeStamp;
    }

    /// @notice Getter function for getRecentWinner  function.
    function getRecentWinner() external view returns(address){
        return s_recentWinner;
    }

}
