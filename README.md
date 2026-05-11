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
    * Verify installation: `forge --version`
* [GIT](https://git-scm.com/)
    * Verify installation: `git --version`

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
### Environment Setup
1. Configure your `.env` file:
   ```shell
      SEPOLIA_RPC_URL=your_sepolia_rpc_url
      ETHERSCAN_SEPOLIA_API_KEY=your_etherscan_api_key
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
## How It Works (Simple Flow)
1. ****Entry Raffle(Phase):**** Players can send the required entrance fee to the contract to join the current raffle round, by calling `enterRaffle()`. The players addresses are stored in an array. What happens here:
    * Checks if a player entry fee is enough.
    * Stores player address.
    * Adds ETH to contract balance.
2. ****Upkeep Check(Automated):**** Chainlink Automation detects that if the raffle is ready to pick a winner or not, based on the following checks:  
    * Raffle entry is in `OPEN` state.
    * Enough time has passed.
    * Contract holds sufficient ETH(atleast 1 to 2 players).
    * Subscription funded(LINK deposit successful).
3. ****Winner Selection:**** When conditions are satisfied, the function `performUpkeep()` is called:
    * Raffle status updated to `CALCULATING`.
    * Random number request initiated (from Chainlink VRF).
4. ****Fulfillment:**** The Chainlink VRF automatically calls the `fulfillRandomWords()`:
    * Random number is received
    * Random winner calculated via modulo.
    * Prize awarded to winner and transfered.
5. ****Raffle Resets for Next Round:**** </br>
    After payout:
    * Players array is cleared.
    * Timestamp is reset.
    * State goes back to OPEN.

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
* ****`NUM_WORDS`:**** The number of words/slots to request from the oracle.
* ****`i_entranceFee`:**** The minimum amount of ETH required to enter the raffle.
* ****`i_interval`:**** Time interval set at deployment (e.g., in seconds).
* ****`i_keyHash`:****  The key hash for the Chainlink VRF Coordinator, identifying the gas lane.
* ****`i_subscriptionId`:**** Subscription ID assigned by Chainlink/external service at deploymen.
* ****`i_callbackGasLimit`:**** The maximum gas allowed for the callback function (e.g., fulfillRandomWords).
* ****`s_players`:****  Array of players allowed to receive ETH, managed privately.

## Configuration
Create a .env file with the following variables:
  ```shell
    SEPOLIA_RPC_URL=your_sepolia_rpc_url
    ETHERSCAN_SEPOLIA_API_KEY=your_etherscan_api_key
  ```

## Project Structure
    ├── script                             #  deployment, configuration, and interaction scripts directory
    │   ├── DeployRaffle.s.sol             # Main deployment script
    │   ├── HelperConfig.s.sol             # Network configuration script
    │   └── Interaction.s.sol              # Chainlink interaction scripts (VRF subscription management)
    ├── src                                # Smart contracts directory 
    │   └── Raffle.sol                     # Smart contracts main source code(raffle contract logic)
    └── test                               # Test files directory
    │     ├── integration
    │     │   └── IntegrationTest.t.sol    # Integration tests
    │     ├── mocks                        # development/testing contract directory
    │     │   └── LinkToken.sol            # dummy testing contract designed to simulate the real Chainlink LINK token on a local blockchain when test with mock
    │     └── unit                    
    │       └── RaffleTest.t.sol           # Unit tests
    ├── lib
    │   ├── forge-std/                     # Foundry standard library
    │   ├── chainlink-brownie-contracts/   # Chainlink contracts
    │   ├── foundry-devops/                # DevOps utilities
    │   └── solmate/                       # Optimized utilities
    ├── foundry.toml                       # Foundry configuration
    ├── Makefile                           # Build commands
    └── README.md                          # This entire text documents file

## Smart Contract Architecture
### Raffle Contract
The main raffle contract implementation:
* Entry raffle fee payment.
* Player registration for the raffle commencement.
* Integration with Chainlink VRF to activate random winner selection.
* Integration with Chainlink Automation for automated, decentralized , periodic draws.
* Raffle Winner Prize distribution.

### Chainlink Integration
* ****VRF (Verifiable Random Function):**** Provides cryptographically secure randomness.
* ****Automation:**** Enables trustless execution of raffle draws based on time intervals.

### Testing
The project includes intensive tests covering:
* Contract deployment.
* Raffle entry flow mechanics.
* Chainlink VRF integration (for randomness).
* Automation functionality.
* Edge cases and error handling.

Run tests with different verbosity levels:
```shell
  forge test                    # Standard output
  forge test -v                 # Verbose
  forge test -vv                # More verbose
  forge test -vvv               # Very verbose
  forge test -vvvv              # Maximum verbosity
```

## Network Configuration
### Local Development (Anvil)
* RPC URL: `http://localhost:8545`
* Chain ID: 31337
* Default funded accounts available already

### Sepolia Testnet
* Requires SEPOLIA_RPC_URL in `.env`
* Requires a testnet sepoliaETH for deployment
* Contracts are verified on Etherscan automatically (E.g sepolia.ethscan.io)


## Security Considerations
* The contract securely transfers Ether to the winner only if it ensures the contract has sufficient balance before processing the transfer.
* Uses Chainlink VRF for cryptographically secure randomness.
* Executes checks-effects-interactions smart contract pattern.
* Fulfils State changes before external calls to prevent reentrancy.
* Intensive test coverage covers edge cases.
* All Raffle randomness is generated using Chainlink VRF service.
* Consider professional audit before mainnet deployment.

## Gas Optimization
* Optimized iteration and data structure operations.
* Implemented custom errors for gas efficiency.
* Efficient storage patterns.


## Makefile
A Makefile is included to streamline commands for cleaning, building, testing, updating, formatting, deployment, and
more. You can use it to execute tasks without needing to remember specific commands. Just run the command you need like this:
```shell
   make <command>
```

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

Built with ❤️ using Foundry and Chainlink
