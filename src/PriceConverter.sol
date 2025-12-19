//SPDX-License-Identifier : MIT
pragma solidity ^0.8.30;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter{
    function getPrice(AggregatorV3Interface Price)internal view returns(uint256){
        ( ,int256 price, , , ) = Price.latestRoundData();
        return (uint256(price) * 1e10);

    }

    function getConversionRate (uint256 ethAmount,AggregatorV3Interface price) internal view returns(uint256) {
        uint256 ethPriceUSD = getPrice(price);
        uint256 amount = ((ethAmount * ethPriceUSD)/1e18);
        return amount;
    }

    function getVersion(address price)internal view returns(uint256){
        AggregatorV3Interface Price = AggregatorV3Interface(price);
        return Price.version();
    }
}
