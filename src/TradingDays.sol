// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
import "forge-std/console.sol";
import { Hooks } from "@uniswap/v4-core/contracts/libraries/Hooks.sol";
import { BaseHook } from "v4-periphery/BaseHook.sol";

import { IPoolManager } from
    "@uniswap/v4-core/contracts/interfaces/IPoolManager.sol";
import { BalanceDelta } from "@uniswap/v4-core/contracts/types/BalanceDelta.sol";

import { BokkyPooBahsDateTimeLibrary as LibDateTime } from
    "BokkyPooBahsDateTimeLibrary/contracts/BokkyPooBahsDateTimeLibrary.sol";
import { HolidayCalendar } from "./HolidayCalendar.sol";
import { LibHolidays, Holiday } from "./LibHolidays.sol";
import { DST } from "./DST.sol";
import { LibDST } from "./LibDST.sol";

contract TradingDays is BaseHook {
    using LibHolidays for HolidayCalendar;
    using LibDST for DST;
    using LibDateTime for uint256;

    /// @notice Data contract encoding NYSE holidays through 2123.
    HolidayCalendar public immutable calendar;

    /// @notice Data contract encoding DST start/end timestamps through 2123.
    DST public immutable dst;

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

    constructor(IPoolManager _poolManager, address _calendar, address _dst)
        BaseHook(_poolManager)
    {
        calendar = HolidayCalendar(_calendar);
        dst = DST(_dst);
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
    function isCoreTradingHours() public view returns (bool) {
        uint256 hour = time().getHour();
        if (hour >= 9 && hour < 16) {
            if (hour == 9) {
                return time().getMinute() >= 30;
            }
            return true;
        }
        return false;
    }

    /// @notice Return true Mon-Fri, if it's not a holiday.
    function isTradingDay() public view returns (bool) {
        return time().isWeekDay() && !isHoliday();
    }

    /// @notice Return true if day is a NYSE holiday.
    function isHoliday() public view returns (bool) {
        (uint256 year, uint256 month, uint256 day) =
            time().timestampToDate();
        return calendar.isHoliday(year, month, day);
    }

    /// @notice Return true if it's Daylight Savings Time.
    function isDST() public view returns (bool) {
        uint256 year = block.timestamp.getYear();
        (uint256 start, uint256 end) = dst.getTimestamps(year);
        return block.timestamp >= start && block.timestamp < end;
    }

    /// @notice Adjust block timestamp to US Eastern Time.
    function time() public view returns (uint256) {
        uint256 offset = isDST() ? 4 hours : 5 hours;
        return block.timestamp - offset;
    }

    /// @notice Get the current holiday from the holiday calendar. Enum values
    ///         indexed from zero are:
    ///
    ///         - NOT_A_HOLIDAY (special value if today is not a holiday)
    ///         - NEW_YEARS_DAY
    ///         - MARTIN_LUTHER_KING_JR_DAY
    ///         - WASHINGTONS_BIRTHDAY
    ///         - GOOD_FRIDAY
    ///         - MEMORIAL_DAY
    ///         - JUNETEENTH_NATIONAL_INDEPENDENCE_DAY
    ///         - INDEPENDENCE_DAY
    ///         - LABOR_DAY
    ///         - THANKSGIVING_DAY
    ///         - CHRISTMAS_DAY
    ///         - NEW_YEARS_DAY_OBSERVED
    ///          (special value if New Year's Day falls on a Saturday)
    ///
    function getHoliday() public view returns (Holiday) {
        (uint256 year, uint256 month, uint256 day) =
            time().timestampToDate();
        return calendar.getHoliday(year, month, day);
    }

    /// @notice Return true if the market is open at current block.timestamp.
    function marketIsOpen() public view returns (bool) {
        return state() == State.OPEN;
    }

    /// @notice Return State at current block.timestamp.
    function state() public view returns (State) {
        if (isHoliday()) return State.HOLIDAY;
        if (time().isWeekEnd()) return State.WEEKEND;
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
            time().timestampToDate();
        // If the market already opened today, don't ring the bell again.
        if (marketOpened[year][month][day]) return;

        // Wow! You get to ring the opening bell!
        marketOpened[year][month][day] = true;
        emit DingDingDing();
    }
}
