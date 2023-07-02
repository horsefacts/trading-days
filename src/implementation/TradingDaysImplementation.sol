// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {TradingDays} from "../TradingDays.sol";

import {BaseHook} from "v4-periphery/BaseHook.sol";
import {IPoolManager} from "@uniswap/v4-core/contracts/interfaces/IPoolManager.sol";
import {Hooks} from "@uniswap/v4-core/contracts/libraries/Hooks.sol";

contract TradingDaysImplementation is TradingDays {
    constructor(IPoolManager poolManager, address calendar, TradingDays addressToEtch) TradingDays(poolManager, calendar) {
        Hooks.validateHookAddress(addressToEtch, getHooksCalls());
    }

    // make this a no-op in testing
    function validateHookAddress(BaseHook _this) internal pure override {}
}
