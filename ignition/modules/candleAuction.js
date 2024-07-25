const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");
const { ethers } = require("ethers");

module.exports = buildModule("CandleAuctionDeployment", (m) => {
    // Define parameters for the CandleAuction contract
    const biddingTime = 1 * 24 * 60 * 60; // 1 day in seconds
    const candleTime = 1 * 60 * 60; // 1 hour in seconds
    const beneficiaryAddress = "0x9A66DcBF9ac92E412C803eF179c0f26240592266"; // Replace with the actual beneficiary address

    // Convert Ether value to Wei
    const bidValue = ethers.parseEther("1.0");

    // Deploy the CandleAuction contract
    const auction = m.contract("CandleAuction", [biddingTime, candleTime, beneficiaryAddress]);

    // Call bid function with specified value
    m.call(auction, "bid", [], { value: bidValue });

    return { auction };
});
