​
# Proveably Random Raffle Smart Contracts
​A decentralized raffle application built with Solidity and Foundry, utilizing Chainlink VRF for provably fair randomness and automated winner selection.


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
* ****Intensive Testing:**** Includes several  testing mechanism. They include: unit tests, integration tests, and fork tests.
* ****Blockchain Transparency:**** Every transaction and role assignment is recorded on the Ethereum blockchain for transparency.
* ****Multi-Network Support:**** Deployable on localhost (Anvil) and Sepolia Eth testnet.
  
## Technology Stack (Technologies Used)
* ****Solidity**** : The programming language for writing the Smart contracts.
* ****Foundry**** : Development framework and testing suite.
* ****Chainlink Automation**** : Decentralized, secure, and cost-efficient Web3 services network.
* ****Chainlink VRF V2.5**** : Tamper-proof random number generator (RNG).

## Getting Started
### Prerequisites
* [FOUNDRY](https://www.getfoundry.sh/introduction/installation)
* [GIT](https://git-scm.com/)

### Installation
1. Clone the repository:
   ```shell
        git clone https://github.com/legendarycode3/raffle-smart-contract
   ```
   ```shell
     cd raffle-smart-contract
   ```
2. Install dependencies:
   ```shell
     make install
   ```
3. Build the project:
   ```shell
     make build
     # or
     forge build
   ```

## Usage
### Building the Project
Compile the smart contracts:
  ```shell
     make build
  ```
### Deploy
Deploy to Sepolia testnet:
  ```shell
    make deploy-sepolia
  ```
### Testing
Run all tests:
  ```shell
    make test
  ```
  Or
  ```shell
    forge test
  ```
Run tests with verbosity:
  ```shell
    make test -vvv
  ```
Run specific test:
  ```shell
    forge test --mt testFunctionName
  ```
Test coverage:
  ```shell
    make coverage
  ```
### Format
 ```shell
    forge fmt
  ```
### Gas Snapshots
You can estimate how much gas things cost by running:
  ```shell
     forge snapshot
  ```
### Cast
  ```shell
     cast <subcommand>
  ```
### Help
  ```shell
    forge --help
    anvil --help
    cast --help
  ```

### Interaction
Enter the raffle:
  ```shell
    cast send <RAFFLE_ADDRESS> "enterRaffle()" --value 0.01ether --rpc-url $SEPOLIA_RPC_URL --account yourEncryptedAccount
  ```
Check raffle state:
  ```shell
    cast call <RAFFLE_ADDRESS> "getRaffleState()" --rpc-url $SEPOLIA_RPC_URL
  ```

## Smart Contract Details
### Main Functions
* ****`enterRaffle()`:**** Enter the raffle after paying the entrance fee
* ****`checkUpkeep()`:**** Ensures to Check if raffle conditions are met for winner selection  
* ****`performUpkeep()`:**** Initiate / Triggers the winner selection process
* ****`fulfillRandomWords()`:**** Randomness request fulfillment function. Callback function for Chainlink VRF

### View Functions
* ****`getEntranceFee()`:**** Returns the minimum ETH required to enter the raffle.
* ****`getRaffleState()`:****  Returns the current state of the raffle (e.g., OPEN, CALCULATING).
* ****`getPlayer(uint256)`:**** Returns the address of a player given their index.
* ****`getLastTimeStamp()`:**** Returns the timestamp of the last recorded action.
* ****`getRecentWinner()`:**** Returns the address of the winner from the previous round.

### Constants and Variables:
* ****`REQUEST_CONFIRMATIONS`:****  How many confirmations the Chainlink node should wait before responding.
* ****`NUM_WORDS`:****
* ****`i_entranceFee`:****
* ****`i_interval`:****
* ****`i_keyHash`:****

## Configuration
Create a .env file with the following variables:
  ```shell
    SEPOLIA_RPC_URL=your_sepolia_rpc_url
    ETHERSCAN_API_KEY=your_etherscan_api_key
  ```

## Project Structure
    ├── script                     #  deployment, configuration, and interaction scripts directory
    │   ├── DeployRaffle.s.sol     # Main deployment script
    │   ├── HelperConfig.s.sol     # configuration script
    │   └── Interaction.s.sol      # Chainlink interaction scripts
    ├── src                        # Smart contracts directory 
    │   └── Raffle.sol             # Smart contracts main source code
    └── test                        # Test files directory
        ├── integration
        │   └── IntegrationTest.t.sol
        ├── mocks                  # development/testing contract directory
        │   └── LinkToken.sol      # dummy testing contract designed to simulate the real Chainlink LINK token on a local blockchain when test with mock
        └── unit
            └── RaffleTest.t.sol
        ├── foundry.toml             # Foundry configuration
        └── README.md                # This entire text documents

## Security Considerations
* The contract securely transfers Ether to the winner only if it ensures the contract has sufficient balance before processing the transfer.
* Uses Chainlink VRF for cryptographically secure randomness.
* Executes checks-effects-interactions smart contract pattern.
* Fulfils State changes before external calls to prevent reentrancy.
* Intensive test coverage covers edge cases.
* Consider professional audit before mainnet deployment

## Gas Optimization
* Optimized iteration and data structure operations
* Implemented custom errors for gas efficiency
* Efficient storage patterns

## Learn More (Resources)
* [Solidity Documentation](https://docs.soliditylang.org/en/v0.8.35-pre.1/)
* [Foundry Documentation](https://www.getfoundry.sh/)
* [Chainlink Documentation](https://docs.chain.link/)
*  [Ethereum Development Resources](https://ethereum.org/developers/)

## Author
### LegendaryCode  
* LinkedIn: [@legendarycode3](https://www.linkedin.com/legendarycode3)
* Twitter: [@legendary_code_](https://x.com/legendary_code_)
* Github: [@legendarycode3](https://github.com/legendarycode3)
Feel free to explore and improve the project. Contributions, issues, and feature requests are welcome!  ❤️

## Conclusion
This project demonstrates how smart contracts on the Ethereum blockchain can enable decentralized and trustless raffle systems. The transparency and immutability of the blockchain ensure fairness through the blockchain technology.
