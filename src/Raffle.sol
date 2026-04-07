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
    address payable[] private s_players;


    event RaffleEntered(address indexed player);

    
    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
    }


    function enterRaffle() public payable {
        // require(msg.value >= i_entranceFee, "Not enough ETH sent!");
        if(msg.value >= i_entranceFee) {
            revert Raffle__SendMoreEThToEnterRaffle();
        }
    }


    function pickWinner() public {

    }


    /**
     * GETTER FUNCTIONS
     */
    function getEntranceFee() external view returns(uint256){
        return i_entranceFee;
    }
}