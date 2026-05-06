​
# Proveably Random Raffle Smart Contracts
​
## Project Overview

## Project Structure

## Features
* ****Decentralized Entry Mechanism:**** Allows participants to buy tickets securely by sending the correct native cryptocurrency (e.g., ETH) or tokens to the contract, eliminating third-party processors.
* ****Provably Fair Randomness (Chainlink VRF):**** Utilizes Verifiable Random Functions (VRF) to generate a secure, transparent, and unpredictable random number to select winners, ensuring the drawing is not manipulated.
* ****Automated Execution (Chainlink Automation):**** Chainlink Automation triggers winner selection  based on specific triggers at predetermined intervals. Uses automated, time-based triggers to close the raffle and initiate the winner selection process without requiring human intervention.
* ****Automated Prize Distribution:****  Automatically sends the accumulated prize pool to the winning address immediately upon drawing the winner, ensuring guaranteed payouts.
* ****Raffle State Management:**** Define distinct states, such as `OPEN`, `CALCULATING` (drawing), and `CLOSED` , to prevent entries after the deadline and manage the lifecycle of the raffle.
* ****Transparency & Auditability:**** All participants, ticket purchases, and winner selections are recorded on a public ledger, allowing anyone to verify the results.
* ****Event Logging:**** Emits events for key actions (e.g., WinnerPicked) that allow interfaces to display real-time updates to users on the blockchain.
* ****Gas Optimization:**** Developed with smart contract best practices for gas efficiency, to reduce cost.
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
