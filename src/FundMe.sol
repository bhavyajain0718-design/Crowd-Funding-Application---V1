//SPDX-License-Identifier : MIT
pragma solidity ^0.8.30;

import {PriceConverter} from "./PriceConverter.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

error NotEnoughETH();
error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINUSD = 5e18;
    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;
    address public immutable i_owner;
    AggregatorV3Interface private s_priceFeed;

    constructor(address PriceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(PriceFeed);
    }

    function fund() public payable {
        if (msg.value.getConversionRate(s_priceFeed) < MINUSD) {
            revert NotEnoughETH();
        }
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function CheaperWithdraw() public OnlyOwner {
        // mappings->0
        // new array
        // withdraw
        uint256 ns_funder = funders.length; // reading from storage var only 1 time
        for (uint256 funderIndex = 0; funderIndex < ns_funder; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        funders = new address[](0);

        (bool sendSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(sendSuccess, "transaction failed");
    }

    function withdraw() public OnlyOwner {
        // mappings->0
        // new array
        // withdraw

        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        funders = new address[](0);

        (bool sendSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(sendSuccess, "transaction failed");
    }

    modifier OnlyOwner() {
        if (msg.sender != i_owner) {
            revert NotOwner();
        }
        _;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    // getter function

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    function getFunders(uint256 index) public view returns (address) {
        return funders[index];
    }

    function getMappings(address funder) public view returns (uint256) {
        return addressToAmountFunded[funder];
    }

    function getOwner() public view returns (address) {
        address ContractOwner = i_owner;
        return (ContractOwner);
    }

    function getOwnerBalance() public view returns (uint256) {
        uint256 ContractOwnerbalance = getOwner().balance;
        return (ContractOwnerbalance);
    }
}
