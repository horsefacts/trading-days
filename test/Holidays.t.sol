// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

import { HolidayCalendar } from "../src/HolidayCalendar.sol";
import { LibHolidays, Holiday } from "../src/LibHolidays.sol";

contract HolidaysTest is Test {
    using LibHolidays for HolidayCalendar;

    HolidayCalendar calendar = new HolidayCalendar();

    function test_Holidays_2023() public {
        assertHolidayDateEq(Holiday.NEW_YEARS_DAY, 2023, 1, 2);
        assertHolidayDateEq(Holiday.MARTIN_LUTHER_KING_JR_DAY, 2023, 1, 16);
        assertHolidayDateEq(Holiday.WASHINGTONS_BIRTHDAY, 2023, 2, 20);
        assertHolidayDateEq(Holiday.GOOD_FRIDAY, 2023, 4, 7);
        assertHolidayDateEq(Holiday.MEMORIAL_DAY, 2023, 5, 29);
        assertHolidayDateEq(
            Holiday.JUNETEENTH_NATIONAL_INDEPENDENCE_DAY, 2023, 6, 19
        );
        assertHolidayDateEq(Holiday.INDEPENDENCE_DAY, 2023, 7, 4);
        assertHolidayDateEq(Holiday.LABOR_DAY, 2023, 9, 4);
        assertHolidayDateEq(Holiday.THANKSGIVING_DAY, 2023, 11, 23);
        assertHolidayDateEq(Holiday.CHRISTMAS_DAY, 2023, 12, 25);

        assertHolidayDateEq(Holiday.NEW_YEARS_DAY_OBSERVED, 2023, 0, 0);
    }

    function test_Holidays_2024() public {
        assertHolidayDateEq(Holiday.NEW_YEARS_DAY, 2024, 1, 1);
        assertHolidayDateEq(Holiday.MARTIN_LUTHER_KING_JR_DAY, 2024, 1, 15);
        assertHolidayDateEq(Holiday.WASHINGTONS_BIRTHDAY, 2024, 2, 19);
        assertHolidayDateEq(Holiday.GOOD_FRIDAY, 2024, 3, 29);
        assertHolidayDateEq(Holiday.MEMORIAL_DAY, 2024, 5, 27);
        assertHolidayDateEq(
            Holiday.JUNETEENTH_NATIONAL_INDEPENDENCE_DAY, 2024, 6, 19
        );
        assertHolidayDateEq(Holiday.INDEPENDENCE_DAY, 2024, 7, 4);
        assertHolidayDateEq(Holiday.LABOR_DAY, 2024, 9, 2);
        assertHolidayDateEq(Holiday.THANKSGIVING_DAY, 2024, 11, 28);
        assertHolidayDateEq(Holiday.CHRISTMAS_DAY, 2024, 12, 25);

        assertHolidayDateEq(Holiday.NEW_YEARS_DAY_OBSERVED, 2024, 0, 0);
    }

    function test_Holidays_2025() public {
        assertHolidayDateEq(Holiday.NEW_YEARS_DAY, 2025, 1, 1);
        assertHolidayDateEq(Holiday.MARTIN_LUTHER_KING_JR_DAY, 2025, 1, 20);
        assertHolidayDateEq(Holiday.WASHINGTONS_BIRTHDAY, 2025, 2, 17);
        assertHolidayDateEq(Holiday.GOOD_FRIDAY, 2025, 4, 18);
        assertHolidayDateEq(Holiday.MEMORIAL_DAY, 2025, 5, 26);
        assertHolidayDateEq(
            Holiday.JUNETEENTH_NATIONAL_INDEPENDENCE_DAY, 2025, 6, 19
        );
        assertHolidayDateEq(Holiday.INDEPENDENCE_DAY, 2025, 7, 4);
        assertHolidayDateEq(Holiday.LABOR_DAY, 2025, 9, 1);
        assertHolidayDateEq(Holiday.THANKSGIVING_DAY, 2025, 11, 27);
        assertHolidayDateEq(Holiday.CHRISTMAS_DAY, 2025, 12, 25);
        assertHolidayDateEq(Holiday.NEW_YEARS_DAY_OBSERVED, 2025, 0, 0);
    }

    function test_Holidays_2027() public {
        assertHolidayDateEq(Holiday.NEW_YEARS_DAY, 2027, 1, 1);
        assertHolidayDateEq(Holiday.NEW_YEARS_DAY_OBSERVED, 2027, 12, 31);
    }

    function test_Holidays_2028() public {
        assertHolidayDateEq(Holiday.NEW_YEARS_DAY, 2028, 0, 0);
        assertHolidayDateEq(Holiday.NEW_YEARS_DAY_OBSERVED, 2028, 0, 0);
    }

    function test_allDates_2023() public {
        (uint256[11] memory months, uint256[11] memory dates) =
            calendar.getAllDates(2023);
        assertEq(months[0], 1);
        assertEq(dates[0], 2);

        assertEq(months[1], 1);
        assertEq(dates[1], 16);

        assertEq(months[2], 2);
        assertEq(dates[2], 20);

        assertEq(months[3], 4);
        assertEq(dates[3], 7);

        assertEq(months[4], 5);
        assertEq(dates[4], 29);

        assertEq(months[5], 6);
        assertEq(dates[5], 19);

        assertEq(months[6], 7);
        assertEq(dates[6], 4);

        assertEq(months[7], 9);
        assertEq(dates[7], 4);

        assertEq(months[8], 11);
        assertEq(dates[8], 23);

        assertEq(months[9], 12);
        assertEq(dates[9], 25);

        // No NYE Observed in 2023
        assertEq(months[10], 0);
        assertEq(dates[10], 0);
    }

    function test_allDates_2027() public {
        (uint256[11] memory months, uint256[11] memory dates) =
            calendar.getAllDates(2027);
        assertEq(months[0], 1);
        assertEq(dates[0], 1);

        assertEq(months[1], 1);
        assertEq(dates[1], 18);

        assertEq(months[2], 2);
        assertEq(dates[2], 15);

        assertEq(months[3], 3);
        assertEq(dates[3], 26);

        assertEq(months[4], 5);
        assertEq(dates[4], 31);

        assertEq(months[5], 6);
        assertEq(dates[5], 18);

        assertEq(months[6], 7);
        assertEq(dates[6], 5);

        assertEq(months[7], 9);
        assertEq(dates[7], 6);

        assertEq(months[8], 11);
        assertEq(dates[8], 25);

        assertEq(months[9], 12);
        assertEq(dates[9], 24);

        assertEq(months[10], 12);
        assertEq(dates[10], 31);
    }

    function test_allDates_2028() public {
        (uint256[11] memory months, uint256[11] memory dates) =
            calendar.getAllDates(2028);

        // No New Year's Day in 2028
        assertEq(months[0], 0);
        assertEq(dates[0], 0);

        assertEq(months[1], 1);
        assertEq(dates[1], 17);

        assertEq(months[2], 2);
        assertEq(dates[2], 21);

        assertEq(months[3], 4);
        assertEq(dates[3], 14);

        assertEq(months[4], 5);
        assertEq(dates[4], 29);

        assertEq(months[5], 6);
        assertEq(dates[5], 19);

        assertEq(months[6], 7);
        assertEq(dates[6], 4);

        assertEq(months[7], 9);
        assertEq(dates[7], 4);

        assertEq(months[8], 11);
        assertEq(dates[8], 23);

        assertEq(months[9], 12);
        assertEq(dates[9], 25);

        // No New Year's Day Observed in 2028
        assertEq(months[10], 0);
        assertEq(dates[10], 0);
    }

    function test_isHoliday() public {
        assertEq(calendar.isHoliday(2023, 1, 2), true);
        assertEq(calendar.isHoliday(2023, 9, 4), true);
        assertEq(calendar.isHoliday(2024, 3, 29), true);
        assertEq(calendar.isHoliday(2025, 6, 19), true);
        assertEq(calendar.isHoliday(2026, 11, 26), true);
    }

    function test_getHoliday() public {
        assertEq(calendar.getHoliday(2023, 1, 2), Holiday.NEW_YEARS_DAY);
        assertEq(calendar.getHoliday(2023, 9, 4), Holiday.LABOR_DAY);
        assertEq(calendar.getHoliday(2024, 3, 29), Holiday.GOOD_FRIDAY);
        assertEq(
            calendar.getHoliday(2025, 6, 19),
            Holiday.JUNETEENTH_NATIONAL_INDEPENDENCE_DAY
        );
        assertEq(calendar.getHoliday(2026, 11, 26), Holiday.THANKSGIVING_DAY);
        assertEq(calendar.getHoliday(2027, 1, 1), Holiday.NEW_YEARS_DAY);
        assertEq(
            calendar.getHoliday(2027, 12, 31), Holiday.NEW_YEARS_DAY_OBSERVED
        );
        assertEq(calendar.getHoliday(2028, 1, 1), Holiday.NOT_A_HOLIDAY);
        assertEq(calendar.getHoliday(2028, 12, 31), Holiday.NOT_A_HOLIDAY);
    }

    function assertHolidayDateEq(
        Holiday h,
        uint256 year,
        uint256 month,
        uint256 day
    ) internal {
        (uint256 m, uint256 d) = calendar.getDate(h, year);
        assertEq(m, month);
        assertEq(d, day);
    }

    function assertEq(Holiday a, Holiday b) internal {
        assertEq(uint256(a), uint256(b));
    }
}
