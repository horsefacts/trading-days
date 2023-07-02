// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Hooks} from "@uniswap/v4-core/contracts/libraries/Hooks.sol";
import {BaseHook} from "v4-periphery/BaseHook.sol";

import {IPoolManager} from "@uniswap/v4-core/contracts/interfaces/IPoolManager.sol";
import {BalanceDelta} from "@uniswap/v4-core/contracts/types/BalanceDelta.sol";

import {BokkyPooBahsDateTimeLibrary as DateTime} from "BokkyPooBahsDateTimeLibrary/contracts/BokkyPooBahsDateTimeLibrary.sol";

contract TradingDays is BaseHook {
    using DateTime for uint256;

    enum Holiday {
        NEW_YEARS_DAY,
        MARTIN_LUTHER_KING_JR_DAY,
        WASHINGTONS_BIRTHDAY,
        GOOD_FRIDAY,
        MEMORIAL_DAY,
        JUNETEENTH_NATIONAL_INDEPENDENCE_DAY,
        INDEPENDENCE_DAY,
        LABOR_DAY,
        THANKSGIVING_DAY,
        CHRISTMAS_DAY
    }

    /// @notice Sorry, trading is closed for the day.
    error MarketClosed();

    /// @notice Ring the opening bell.
    event DingDingDing();

    /// @notice Year/month/day mapping recording whether the market opened.
    mapping(uint256 => mapping(uint256 => mapping(uint256 => bool))) public marketOpened;

    constructor(IPoolManager _poolManager) BaseHook(_poolManager) {}

    function getHooksCalls() public pure override returns (Hooks.Calls memory) {
        return Hooks.Calls({
            beforeInitialize: false,
            afterInitialize: false,
            beforeModifyPosition: false,
            afterModifyPosition: false,
            beforeSwap: true,
            afterSwap: false,
            beforeDonate: false,
            afterDonate: false
        });
    }

    /// @notice Return true between 9:30 AM and 4:00 PM ET.
    /// @dev TODO: Daylight savings time.
    function isCoreTradingHours() public view returns (bool) {
        uint256 hour = block.timestamp.getHour();
        if (hour >= 13 && hour < 20) {
            if (hour == 13) {
                return block.timestamp.getMinute() >= 30;
            }
            return true;
        }
        return false;
    }

    /// @notice Return true Mon-Fri, if it's not a holiday.
    function isTradingDay() public view returns (bool) {
        return block.timestamp.isWeekDay() && !isHoliday();
    }

    /// @dev TODO: Implement holiday calendar.
    function isHoliday() public pure returns (bool) {
        return false;
    }

    function marketIsOpen() public view returns (bool) {
        return isTradingDay() && isCoreTradingHours();
    }

    /// @dev The first swap of the trading day rings the opening bell.
    function _ringOpeningBell() internal {
        (uint256 year, uint256 month, uint256 day) = block.timestamp.timestampToDate();
        if(!marketOpened[year][month][day]) {
           marketOpened[year][month][day] = true;
           emit DingDingDing();
        }
    }

    function beforeSwap(address, IPoolManager.PoolKey calldata, IPoolManager.SwapParams calldata)
        external
        override
        returns (bytes4)
    {
        if (!marketIsOpen()) revert MarketClosed();
        _ringOpeningBell();

        return BaseHook.beforeSwap.selector;
    }
}
