//SPDX-License-Idnetifier:MIT
pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/Mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    address public activePriceFeed;
    uint8 public DECIMAL = 8;
    int256 public INITIAL_VALUE = 2000e8;
    address public SepoliaPriceFeed = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
    address public EthMainnetPriceFeed = 0x5147eA642CAEF7BD9c1265AadcA78f997AbB9649;
    address public ArbMainnetPriceFeed = 0x639Fe6ab55C921f74e7fac1ee960C0B6293ba612;

    constructor() {
        if (block.chainid == 11155111) {
            activePriceFeed = SepoliaEthConfig();
        } else if (block.chainid == 1) {
            activePriceFeed = EthMainnetConfig();
        } else if (block.chainid == 42161) {
            activePriceFeed = ArbMainnetConfig();
        } else {
            activePriceFeed = AnvilEthConfig();
        }
    }

    function SepoliaEthConfig() public view returns (address) {
        address priceFeed = SepoliaPriceFeed;
        return priceFeed;
    }

    function EthMainnetConfig() public view returns (address) {
        address priceFeed = EthMainnetPriceFeed;
        return priceFeed;
    }

    function ArbMainnetConfig() public view returns (address) {
        address priceFeed = ArbMainnetPriceFeed;
        return priceFeed;
    }

    function AnvilEthConfig() public returns (address) {
        if (activePriceFeed != address(0)) {
            return (activePriceFeed);
        }

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeedInterface = new MockV3Aggregator(DECIMAL, INITIAL_VALUE);
        vm.stopBroadcast();

        address AnvilPriceFeedAddress = address(mockPriceFeedInterface);
        return (AnvilPriceFeedAddress);
    }
}
