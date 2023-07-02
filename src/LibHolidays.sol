// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {HolidayCalendar} from "./HolidayCalendar.sol";

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

library LibHolidays {

    error YearNotFound();

    function getDate(HolidayCalendar calendar, Holiday holiday, uint256 year) internal view returns (uint256 month, uint256 day) {
        if (year < 2023 || year > 2026) revert YearNotFound();

        // There are 10 holidays in a NYSE trading year. The month and day of
        // each holiday is stored 9 bits: 4 for the month and 5 for the day.
        // That makes 90 bits for a full year, which fits in 12 bytes. Each
        // year's schedule is stored as 12 bytes, starting from 2023 at offset
        // 1. (The first byte is the STOP opcode.)
        assembly {
            extcodecopy(calendar, 0x14, add(1, mul(sub(year, 2023), 0xc)), 0xc)
            let schedule := mload(0)
            let date := shr(mul(sub(9, holiday), 9), schedule)
            month := shr(5, and(date, 0x1e0))
            day := and(date, 0x1f)
        }
    }

    function getAllDates(HolidayCalendar calendar, uint256 year) internal view returns (uint256[10] memory months, uint256[10] memory dates) {
        if (year < 2023 || year > 2026) revert YearNotFound();

        assembly {
            extcodecopy(calendar, 0x14, add(1, mul(sub(year, 2023), 0xc)), 0xc)
            let schedule := mload(0)
            let monthPtr := months
            let dayPtr := dates
            for {let i := 0} lt(i, 10) {i := add(i, 1)} {
                let date := shr(mul(sub(9, i), 9), schedule)
                mstore(monthPtr, shr(5, and(date, 0x1e0)))
                mstore(dayPtr, and(date, 0x1f))
                monthPtr := add(monthPtr, 0x20)
                dayPtr := add(dayPtr, 0x20)
            }
        }
    }

    function isHoliday(HolidayCalendar calendar, uint256 year, uint256 month, uint256 day) internal view returns (bool _isHoliday) {
        if (year < 2023 || year > 2026) revert YearNotFound();

        assembly {
            extcodecopy(calendar, 0x14, add(1, mul(sub(year, 2023), 0xc)), 0xc)
            let schedule := mload(0)
            for {let i := 0} lt(i, 10) {i := add(i, 1)} {
                let date := shr(mul(sub(9, i), 9), schedule)
                _isHoliday := and(
                    eq(month, shr(5, and(date, 0x1e0))),
                    eq(day, and(date, 0x1f))
                )
                if _isHoliday { break }
            }
        }
    }


}
