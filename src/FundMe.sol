//SPDX-License-Identifier : MIT
pragma solidity ^0.8.30

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";


contract fundme{

    uint256 constant MINUSD = 5e18;

    function fund()public{
        require(msg.value>MINUSD,"didn't send enough eth");
    }

    function getPrice()public{

    }

}