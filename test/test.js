const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
    const CandleAuction = await ethers.getContractFactory("CandleAuction");
    const auctionAddress = "0x9A66DcBF9ac92E412C803eF179c0f26240592266"; // Replace with the deployed contract address

    const auction = await CandleAuction.attach(auctionAddress);

    // Check the current status
    const status = await auction.status();
    console.log("Auction Status:", status);

    // Place a bid
    const bidValue = ethers.parseEther("1.0");
    await auction.bid({ value: bidValue });

    // End the auction
    await auction.auctionEnd();
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
