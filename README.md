​
# Proveably Random Raffle Smart Contracts
​

## Project Overview
The project is a decentralized Raffle/Lottery system which :
* Allows Users to enter a raffle , after paying an entrance fee.
* Winners are selected at random using Chainlink VRF (Verifiable Random Function).
* A Winner selection is automated using Chainlink Automation (which automatically triggers the draw after a set time or a certain number of participants).
* The entire prize pool is automatically sent to the winner address, immediately upon drawing the winner, ensuring guaranteed payouts.


## Features
* ****Decentralized Entry Mechanism:**** Allows participants to buy tickets securely by sending the correct native cryptocurrency (e.g., ETH) or tokens to the contract, eliminating third-party processors.
* ****Provably Fair Randomness (Chainlink VRF):**** Utilizes Verifiable Random Functions (VRF) to generate a secure, transparent, and unpredictable random number to select winners, ensuring the drawing is not manipulated.
* ****Automated Execution (Chainlink Automation):**** Chainlink Automation triggers winner selection  based on specific triggers at predetermined intervals. Uses automated, time-based triggers to close the raffle and initiate the winner selection process without requiring human intervention.
* ****Automated Prize Distribution:****  Automatically sends the accumulated prize pool to the winning address immediately upon drawing the winner, ensuring guaranteed payouts.
* ****Raffle State Management:**** Define distinct states, such as `OPEN`, `CALCULATING` (drawing), and `CLOSED` , to prevent entries after the deadline and manage the lifecycle of the raffle.
* ****Gas Optimization:**** Developed with smart contract best practices for gas efficiency, to reduce cost.
* ****Transparency & Auditability:**** All participants, ticket purchases, and winner selections are recorded on a public ledger, allowing anyone to verify the results.
* ****Event Logging:**** Emits events for key actions (e.g., WinnerPicked) that allow interfaces to display real-time updates to users on the blockchain.
* ****Intensive Testing:**** Includes several testing mechanism. They include: unit tests, integration tests, and fork tests.
  
## Technology Stack (Technologies Used)
* ****Solidity**** : The programming language for writing the Smart contracts.
* ****Foundry**** : Development framework and testing suite.
* ****Chainlink Automation**** : Decentralized, secure, and cost-efficient Web3 services network.
* ****Chainlink VRF V2.5**** : Tamper-proof random number generator (RNG).

## Getting Started
### Prerequisites
* [FOUNDRY](https://www.getfoundry.sh/introduction/installation)
* [GIT](https://git-scm.com/)

## Project Structure
    ├── script
    │   ├── DeployRaffle.s.sol
    │   ├── HelperConfig.s.sol
    │   └── Interaction.s.sol
    ├── src
    │   └── Raffle.sol
    └── test
        ├── integration
        │   └── IntegrationTest.t.sol
        ├── mocks
        │   └── LinkToken.sol
        └── unit
            └── RaffleTest.t.sol
        ├── foundry.toml
        └── README.md

## Security Considerations
* The contract securely transfers Ether to the winner only if it ensures the contract has sufficient balance before processing the transfer.
* Uses Chainlink VRF for cryptographically secure randomness.
* Executes checks-effects-interactions smart contract pattern.
* Fulfils State changes before external calls to prevent reentrancy.
* Intensive test coverage.

## Author
Feel free to explore and improve the project. Contributions, issues, and feature requests are welcome!  ❤️

## Conclusion
