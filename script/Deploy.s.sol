// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Script.sol";

import { Deployer } from "./Deployer.sol";
import { TradingView } from "../src/TradingView.sol";

contract Deploy is Script, Deployer {

    function run() public {
        console.log(
            pad("State", 10),
            pad("Name", 13),
            pad("Address", 43),
            "Initcode hash"
        );
        vm.startBroadcast();
        deploy(
            "TradingView",
            bytes32(0x79d31bfca5fda7a4f15b36763d2e44c99d811a6cd58a3a63cf9e7f0097a11f1e),
            type(TradingView).creationCode
        );
    }
}
