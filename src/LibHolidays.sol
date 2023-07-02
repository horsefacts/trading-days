// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {HolidayCalendar} from "./HolidayCalendar.sol";

enum Holiday {
    NOT_A_HOLIDAY,
    NEW_YEARS_DAY,
    MARTIN_LUTHER_KING_JR_DAY,
    WASHINGTONS_BIRTHDAY,
    GOOD_FRIDAY,
    MEMORIAL_DAY,
    JUNETEENTH_NATIONAL_INDEPENDENCE_DAY,
    INDEPENDENCE_DAY,
    LABOR_DAY,
    THANKSGIVING_DAY,
    CHRISTMAS_DAY,
    NEW_YEARS_DAY_OBSERVED
}

library LibHolidays {

    error YearNotFound();
    error NotAHoliday();

    function getDate(HolidayCalendar calendar, Holiday holiday, uint256 year) internal view returns (uint256 month, uint256 day) {
        if (year < 2023) revert YearNotFound();
        if (holiday == Holiday.NOT_A_HOLIDAY) revert NotAHoliday();

        // There are up to 11 trading holidays in a calendar year, depending on
        // when New Year's Day is observed. If New Year's Day falls on Sat, it
        // may be observed on the Friday of the previous year. So we need to
        // store up to 11 dates per year.

        // We store the month and day of each holiday in 9 bits: 4 for the month
        // and 5 for the day. That makes 99 bits for a full year of holidays,
        // which fits in 13 bytes. We store each year's calendar as 13 bytes of
        // contract code, starting from 2023 at offset 1. (The first byte of the
        // data contract is the STOP opcode.)
        assembly {
            extcodecopy(calendar, 0x13, add(1, mul(sub(year, 2023), 0xd)), 0xd)
            let schedule := mload(0)
            let date := shr(mul(sub(10, sub(holiday, 1)), 9), schedule)
            month := shr(5, and(date, 0x1e0))
            day := and(date, 0x1f)
        }
    }

    function getAllDates(HolidayCalendar calendar, uint256 year) internal view returns (uint256[11] memory months, uint256[11] memory dates) {
        if (year < 2023) revert YearNotFound();

        assembly {
            extcodecopy(calendar, 0x13, add(1, mul(sub(year, 2023), 0xd)), 0xd)
            let schedule := mload(0)
            let monthPtr := add(months, mul(10, 0x20))
            let dayPtr := add(dates, mul(10, 0x20))
            for {let i := 11} gt(i, 0) {i := sub(i, 1)} {
                let date := shr(mul(sub(11, i), 9), schedule)
                mstore(monthPtr, shr(5, and(date, 0x1e0)))
                mstore(dayPtr, and(date, 0x1f))
                monthPtr := sub(monthPtr, 0x20)
                dayPtr := sub(dayPtr, 0x20)
            }
        }
    }

    function isHoliday(HolidayCalendar calendar, uint256 year, uint256 month, uint256 day) internal view returns (bool _isHoliday) {
        return getHoliday(calendar, year, month, day) != Holiday.NOT_A_HOLIDAY;
    }

    function getHoliday(HolidayCalendar calendar, uint256 year, uint256 month, uint256 day) internal view returns (Holiday h) {
        if (year < 2023) revert YearNotFound();

        assembly {
            extcodecopy(calendar, 0x13, add(1, mul(sub(year, 2023), 0xd)), 0xd)
            let schedule := mload(0)
            for {let i := 11} gt(i, 0) {i := sub(i, 1)} {
                let date := shr(mul(sub(11, i), 9), schedule)
                let _isHoliday := and(
                    eq(month, shr(5, and(date, 0x1e0))),
                    eq(day, and(date, 0x1f))
                )
                if _isHoliday {
                    h := i
                    break
                }
            }
        }
    }


}
