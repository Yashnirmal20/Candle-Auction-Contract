
# Candle Auction Smart Contract

A smart contract implementing a time-based auction system with dynamic extension based on bid timing. This contract is tested and deployed using Hardhat and Hardhat Ignition.

### Description

The CandleAuction smart contract allows for an auction where the highest bid wins. The auction has a dynamic end time that can be extended based on random intervals when bids are placed close to the end time.

### Installation

1. Clone the repository
git clone https://github.com/Yashnirmal20/Candle-Auction-Contract.git

2. Install the dependencies
npm install

### Compiling the contract

To compile the smart contract, run:

npx hardhat compile

### Deploying the contract

To deploy the contract on a local network using Hardhat, run:

npx hardhat ignition deploy ignition/modules/candleAuction.js --network localhost

### Testing

To run the tests, use the following command:

npx hardhat test

### Running the Candle Auction demo
#### Ensure you have Node.js and npm installed. You will also need Hardhat and Hardhat Ignition

#### Setting up the local network

npx hardhat node

#### Deploy the contract to the local network:

npx hardhat ignition deploy ignition/modules/candleAuction.js --network localhost

### Bidding in the Auction

Open a new terminal window and run the Hardhat console:

npx hardhat console --network localhost

Get the deployed contract instance:

const CandleAuction = await ethers.getContractFactory("CandleAuction");
const auction = await CandleAuction.attach("deployed_contract_address");

Place a bid: 

await auction.bid({ value: ethers.utils.parseEther("1.0") });

Check the highest bid: 

const highestBid = await auction.highestBid();
console.log(ethers.utils.formatEther(highestBid));

### Ending the Auction

End the auction after the candle end time:

await auction.auctionEnd();

Check the auction status and winner:

const ended = await auction.ended();
const winner = await auction.highestBidder();
console.log(`Auction ended: ${ended}, Winner: ${winner}`);

### Withdrawing Funds

await auction.withdraw();


### Contact Information

Mail: yash.ethh@gmail.com







