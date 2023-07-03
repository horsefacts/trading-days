// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {
    TradingDays,
    HolidayCalendar,
    DaylightSavingsCalendar
} from "./TradingDays.sol";

/// @title TradingView
/// @author horsefacts <horsefacts@terminally.online>
/// @notice View-only version of TradingDays.
contract TradingView is
    TradingDays(
        new HolidayCalendar(),
        new DaylightSavingsCalendar()
    )
{ }
