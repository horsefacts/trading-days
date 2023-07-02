// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import { Hooks } from "@uniswap/v4-core/contracts/libraries/Hooks.sol";
import { BaseHook } from "v4-periphery/BaseHook.sol";

import { IPoolManager } from
    "@uniswap/v4-core/contracts/interfaces/IPoolManager.sol";
import { BalanceDelta } from "@uniswap/v4-core/contracts/types/BalanceDelta.sol";

import { BokkyPooBahsDateTimeLibrary as LibDateTime } from
    "BokkyPooBahsDateTimeLibrary/contracts/BokkyPooBahsDateTimeLibrary.sol";
import { HolidayCalendar } from "./HolidayCalendar.sol";
import { LibHolidays, Holiday } from "./LibHolidays.sol";

contract TradingDays is BaseHook {
    using LibHolidays for HolidayCalendar;
    using LibDateTime for uint256;

    /// @notice Data contract encoding NYSE holidays through 2123.
    HolidayCalendar public immutable calendar;

    enum State {
        HOLIDAY,
        WEEKEND,
        AFTER_HOURS,
        OPEN
    }

    /// @notice No trading today, markets are closed for a holiday.
    error ClosedForHoliday(Holiday holiday);

    /// @notice It's the weekend. Log off and touch grass.
    error ClosedForWeekend();

    /// @notice Sorry, everyone in New York has gone home for the day.
    error AfterHours();

    /// @notice Ring the opening bell.
    event DingDingDing();

    /// @notice Year/month/day mapping recording whether the market opened.
    mapping(uint256 => mapping(uint256 => mapping(uint256 => bool))) public
        marketOpened;

    constructor(IPoolManager _poolManager, address _calendar)
        BaseHook(_poolManager)
    {
        calendar = HolidayCalendar(_calendar);
    }

    function getHooksCalls()
        public
        pure
        override
        returns (Hooks.Calls memory)
    {
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
    /// @dev TODO: Timezone adjustment from UTC.
    function isTradingDay() public view returns (bool) {
        return block.timestamp.isWeekDay() && !isHoliday();
    }

    /// @notice Return true if day is a NYSE holiday.
    /// @dev TODO: Timezone adjustment from UTC.
    function isHoliday() public view returns (bool) {
        (uint256 year, uint256 month, uint256 day) =
            block.timestamp.timestampToDate();
        return calendar.isHoliday(year, month, day);
    }

    /// @notice Get the current holiday from the holiday calendar. See the
    ///         Holiday enum in LibHoliday.sol for the full list of holidays.
    /// @dev TODO: Daylight savings time.
    function getHoliday() public view returns (Holiday) {
        (uint256 year, uint256 month, uint256 day) =
            block.timestamp.timestampToDate();
        return calendar.getHoliday(year, month, day);
    }

    /// @notice Return true if the market is open at current block.timestamp.
    function marketIsOpen() public view returns (bool) {
        return state() == State.OPEN;
    }

    /// @notice Return State of the market at current block.timestamp.
    function state() public view returns (State) {
        if (isHoliday()) return State.HOLIDAY;
        if (block.timestamp.isWeekEnd()) return State.WEEKEND;
        if (!isCoreTradingHours()) return State.AFTER_HOURS;
        return State.OPEN;
    }

    function beforeSwap(
        address,
        IPoolManager.PoolKey calldata,
        IPoolManager.SwapParams calldata
    ) external override returns (bytes4) {
        State s = state();

        if (s == State.OPEN) {
            _ringOpeningBell();
        } else if (s == State.HOLIDAY) {
            revert ClosedForHoliday(getHoliday());
        } else if (s == State.WEEKEND) {
            revert ClosedForWeekend();
        } else if (s == State.AFTER_HOURS) {
            revert AfterHours();
        }

        return BaseHook.beforeSwap.selector;
    }

    /// @dev The first swap of the trading day rings the opening bell.
    function _ringOpeningBell() internal {
        (uint256 year, uint256 month, uint256 day) =
            block.timestamp.timestampToDate();
        // If the market already opened today, don't ring the bell again.
        if (marketOpened[year][month][day]) return;

        // Wow! You get to ring the opening bell!
        marketOpened[year][month][day] = true;
        emit DingDingDing();
    }
}
