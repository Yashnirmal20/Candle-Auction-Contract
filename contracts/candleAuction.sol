// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CandleAuction {
    address payable public beneficiary;
    uint public auctionEndTime;
    uint public candleEndTime;
    uint public minBiddingTime;
    bool public ended;

    address public highestBidder;
    uint public highestBid;

    mapping(address => uint) pendingReturns;

    event HighestBidIncreased(address indexed bidder, uint amount);
    event AuctionEnded(address indexed winner, uint amount);

    modifier onlyBeforeEnd() {
        require(block.timestamp <= auctionEndTime, "Auction already ended.");
        _;
    }

    modifier onlyAfterEnd() {
        require(block.timestamp >= candleEndTime, "Auction not yet ended.");
        _;
    }

    constructor (uint _biddingTime, uint _candleTime, address payable _beneficiary) {
        beneficiary = _beneficiary;
        auctionEndTime = block.timestamp + _biddingTime;
        minBiddingTime = _biddingTime;
        candleEndTime = auctionEndTime + _candleTime;
    }

    function bid() public payable onlyBeforeEnd {
        require (msg.value > highestBid, "There already is a higher bid.");

        if (highestBid != 0) {
            pendingReturns[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
        emit HighestBidIncreased(msg.sender, msg.value);

        if (block.timestamp > auctionEndTime && block.timestamp < candleEndTime) {
            extendAuction();
        }
    }

    function extendAuction() internal {
        uint randomness = generateRandomNumber();
        auctionEndTime = block.timestamp + (randomness % minBiddingTime);
    }

    function generateRandomNumber() internal view returns(uint) {
        // using block prevrandao and timestamp as the source of pseudorandomness
        return uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp)));
    }

    function withdraw() public returns(bool) {
        uint amount = pendingReturns[msg.sender];
        require(amount > 0, "No funds to withdraw.");

        pendingReturns[msg.sender] = 0;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        if (!success) {
            pendingReturns[msg.sender] = amount;
            return false;
        } else {
            return true;
        }
    }

    function auctionEnd() public onlyAfterEnd {
        require (!ended, "Auction has already ended.");

        ended = true;
        emit AuctionEnded(highestBidder, highestBid);

        (bool success, ) = beneficiary.call{value: highestBid}("");
        require(success, "Failed to send funds to beneficiary.");
    }
}