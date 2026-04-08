// Layout of Contract:
// license
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// internal & private view & pure functions
// external & public view & pure functions



// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.19;


/**
 * @title  A Sample Raffle Contract
 * @author  LegendaryCode 
 * @notice  This contract is for creating a sample raffle 
 * @dev     Implements Chainlink  VRFv2.5
 */


contract Raffle {
    

    /** Errors */
    error Raffle__SendMoreEThToEnterRaffle();


    uint256 private immutable i_entranceFee;
    uint256 private immutable i_interval;
    address payable[] private s_players;
    // @dev The duration of the lottery in seconds.
    uint256 private s_lastTimeStamp;


    event RaffleEntered(address indexed player);

    
    constructor(uint256 entranceFee, uint256 intervl) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        s_lastTimeStamp = block.timestamp;
    }


    function enterRaffle() external payable {
        // require(msg.value >= i_entranceFee, "Not enough ETH sent!");
        if(msg.value >= i_entranceFee) {
            revert Raffle__SendMoreEThToEnterRaffle();
        }

        s_players.push(payable(msg.sender));
        emit RaffleEntered(msg.sender);
    }


    // 1. Get a random num.
    // 2. Use that random num, to pick a player(s_players).
    // 3. Be able to do this all time , automatically.
    function pickWinner() external {
        
        //Check to see if enough time has passed
        if ((block.timestamp - s_lastTimeStamp) > i_interval) {
            revert();
        }
    }


    /**
     * GETTER FUNCTIONS
     */
    function getEntranceFee() external view returns(uint256){
        return i_entranceFee;
    }
}