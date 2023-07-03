// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import { HolidayCalendar } from "./HolidayCalendar.sol";

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

library HolidaysLibrary {
    /// @notice LibHoliday supports 100 years of holidays from 2023 to 2123.
    ///         Years outside this range revert with this error.
    error YearNotFound();

    /// Revert if a function expecting a holiday is called with NOT_A_HOLIDAY.
    error NotAHoliday();

    /// @dev 32 bytes, one EVM word.
    uint256 private constant ONE_WORD = 0x20;

    /// @dev Size of the leading STOP opcode byte in the data contract.
    uint256 private constant STOP_BYTE = 0x1;

    /// @dev One year of holidays, encoded as 13 bytes of contract code.
    uint256 private constant ONE_YEAR = 0xd;

    /// @dev Offset copied bytes by 19 bytes, so the 13 byte holiday schedule
    //       is laid out at the end of a 32-byte word in scratch space.
    uint256 private constant COPY_OFFSET = 0x13;

    /// @dev Alias for scratch space memory address.
    uint256 private constant SCRATCH_SPACE = 0x0;

    /// @dev Width of one encoded holiday in bits.
    uint256 private constant HOLIDAY_BIT_WIDTH = 9;

    /// @dev Width of one encoded month in bits.
    uint256 private constant MONTH_BIT_WIDTH = 5;

    /// @dev Mask to extract month from an encoded holiday.
    ///      0x1e0 == 0b111100000
    uint256 private constant MONTH_BIT_MASK = 0x1e0;

    /// @dev Mask to extract day from an encoded holiday.
    ///      0x1f == 0b000011111
    uint256 private constant DAY_BIT_MASK = 0x1f;

    // There are up to 11 trading holidays in a calendar year, depending on
    // when New Year's Day is observed. If New Year's Day falls on Sat, it
    // may be observed on the Friday of the previous year. So we need to
    // store up to 11 dates per year.

    // We store the month and day of each holiday in 9 bits: 4 for the month
    // and 5 for the day. That makes 99 bits for a full year of holidays,
    // which fits in 13 bytes. We store each year's calendar as 13 bytes of
    // contract code, starting from 2023 at offset 1. (The first byte of the
    // data contract is the STOP opcode.)

    /// @notice Get the month and day of the given holiday in the given year
    function getDate(HolidayCalendar calendar, Holiday holiday, uint256 year)
        internal
        view
        returns (uint256 month, uint256 day)
    {
        if (year < 2023 || year > 2123) revert YearNotFound();
        if (holiday == Holiday.NOT_A_HOLIDAY) revert NotAHoliday();

        assembly ("memory-safe") {
            extcodecopy(
                calendar,
                COPY_OFFSET,
                add(STOP_BYTE, mul(sub(year, 2023), ONE_YEAR)),
                ONE_YEAR
            )
            let schedule := mload(SCRATCH_SPACE)
            let date :=
                shr(mul(sub(10, sub(holiday, 1)), HOLIDAY_BIT_WIDTH), schedule)
            month := shr(MONTH_BIT_WIDTH, and(date, MONTH_BIT_MASK))
            day := and(date, DAY_BIT_MASK)
        }
    }

    /// @notice Get all holidays in the given year, as month/day arrays.
    ///         index in the array is the same as the Holiday enum value.
    function getAllDates(HolidayCalendar calendar, uint256 year)
        internal
        view
        returns (uint256[11] memory months, uint256[11] memory dates)
    {
        if (year < 2023 || year > 2123) revert YearNotFound();

        assembly ("memory-safe") {
            extcodecopy(
                calendar,
                COPY_OFFSET,
                add(STOP_BYTE, mul(sub(year, 2023), ONE_YEAR)),
                ONE_YEAR
            )
            let schedule := mload(SCRATCH_SPACE)
            let monthPtr := add(months, mul(10, ONE_WORD))
            let dayPtr := add(dates, mul(10, ONE_WORD))
            for { let i := 11 } gt(i, 0) { i := sub(i, 1) } {
                let date := shr(mul(sub(11, i), HOLIDAY_BIT_WIDTH), schedule)
                mstore(
                    monthPtr, shr(MONTH_BIT_WIDTH, and(date, MONTH_BIT_MASK))
                )
                mstore(dayPtr, and(date, DAY_BIT_MASK))
                monthPtr := sub(monthPtr, ONE_WORD)
                dayPtr := sub(dayPtr, ONE_WORD)
            }
        }
    }

    /// @notice Get the Holiday for a given date. Returns special value
    ///         Holiday.NOT_A_HOLIDAY if the date is not a holiday.
    function getHoliday(
        HolidayCalendar calendar,
        uint256 year,
        uint256 month,
        uint256 day
    ) internal view returns (Holiday h) {
        if (year < 2023 || year > 2123) revert YearNotFound();

        assembly ("memory-safe") {
            extcodecopy(
                calendar,
                COPY_OFFSET,
                add(STOP_BYTE, mul(sub(year, 2023), ONE_YEAR)),
                ONE_YEAR
            )
            let schedule := mload(SCRATCH_SPACE)
            for { let i := 11 } gt(i, 0) { i := sub(i, 1) } {
                let date := shr(mul(sub(11, i), HOLIDAY_BIT_WIDTH), schedule)
                let _isHoliday :=
                    and(
                        eq(month, shr(MONTH_BIT_WIDTH, and(date, MONTH_BIT_MASK))),
                        eq(day, and(date, DAY_BIT_MASK))
                    )
                if _isHoliday {
                    h := i
                    break
                }
            }
        }
    }

    /// @notice Return true if the given year/month/day is a holiday.
    function isHoliday(
        HolidayCalendar calendar,
        uint256 year,
        uint256 month,
        uint256 day
    ) internal view returns (bool _isHoliday) {
        return getHoliday(calendar, year, month, day) != Holiday.NOT_A_HOLIDAY;
    }
}
