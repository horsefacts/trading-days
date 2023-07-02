// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

import {HolidayCalendar} from "../src/HolidayCalendar.sol";
import {LibHolidays, Holiday} from "../src/LibHolidays.sol";

contract HolidaysTest is Test {
    using LibHolidays for HolidayCalendar;

    HolidayCalendar calendar = new HolidayCalendar();

    function test_Holidays2023() public {
        (uint256 month, uint256 day) = calendar.getDate(Holiday.NEW_YEARS_DAY, 2023);
        assertEq(month, 1);
        assertEq(day, 2);

        (month, day) = calendar.getDate(Holiday.MARTIN_LUTHER_KING_JR_DAY, 2023);
        assertEq(month, 1);
        assertEq(day, 16);

        (month, day) = calendar.getDate(Holiday.WASHINGTONS_BIRTHDAY, 2023);
        assertEq(month, 2);
        assertEq(day, 20);

        (month, day) = calendar.getDate(Holiday.GOOD_FRIDAY, 2023);
        assertEq(month, 4);
        assertEq(day, 7);

        (month, day) = calendar.getDate(Holiday.MEMORIAL_DAY, 2023);
        assertEq(month, 5);
        assertEq(day, 29);

        (month, day) = calendar.getDate(Holiday.JUNETEENTH_NATIONAL_INDEPENDENCE_DAY, 2023);
        assertEq(month, 6);
        assertEq(day, 19);

        (month, day) = calendar.getDate(Holiday.INDEPENDENCE_DAY, 2023);
        assertEq(month, 7);
        assertEq(day, 4);

        (month, day) = calendar.getDate(Holiday.LABOR_DAY, 2023);
        assertEq(month, 9);
        assertEq(day, 4);

        (month, day) = calendar.getDate(Holiday.THANKSGIVING_DAY, 2023);
        assertEq(month, 11);
        assertEq(day, 23);

        (month, day) = calendar.getDate(Holiday.CHRISTMAS_DAY, 2023);
        assertEq(month, 12);
        assertEq(day, 25);
    }

    function test_Holidays2024() public {
        (uint256 month, uint256 day) = calendar.getDate(Holiday.NEW_YEARS_DAY, 2024);
        assertEq(month, 1);
        assertEq(day, 1);

        (month, day) = calendar.getDate(Holiday.MARTIN_LUTHER_KING_JR_DAY, 2024);
        assertEq(month, 1);
        assertEq(day, 15);

        (month, day) = calendar.getDate(Holiday.WASHINGTONS_BIRTHDAY, 2024);
        assertEq(month, 2);
        assertEq(day, 19);

        (month, day) = calendar.getDate(Holiday.GOOD_FRIDAY, 2024);
        assertEq(month, 3);
        assertEq(day, 29);

        (month, day) = calendar.getDate(Holiday.MEMORIAL_DAY, 2024);
        assertEq(month, 5);
        assertEq(day, 27);

        (month, day) = calendar.getDate(Holiday.JUNETEENTH_NATIONAL_INDEPENDENCE_DAY, 2024);
        assertEq(month, 6);
        assertEq(day, 19);

        (month, day) = calendar.getDate(Holiday.INDEPENDENCE_DAY, 2024);
        assertEq(month, 7);
        assertEq(day, 4);

        (month, day) = calendar.getDate(Holiday.LABOR_DAY, 2024);
        assertEq(month, 9);
        assertEq(day, 2);

        (month, day) = calendar.getDate(Holiday.THANKSGIVING_DAY, 2024);
        assertEq(month, 11);
        assertEq(day, 28);

        (month, day) = calendar.getDate(Holiday.CHRISTMAS_DAY, 2024);
        assertEq(month, 12);
        assertEq(day, 25);
    }

    function test_Holidays2025() public {
        (uint256 month, uint256 day) = calendar.getDate(Holiday.NEW_YEARS_DAY, 2025);
        assertEq(month, 1);
        assertEq(day, 1);

        (month, day) = calendar.getDate(Holiday.MARTIN_LUTHER_KING_JR_DAY, 2025);
        assertEq(month, 1);
        assertEq(day, 20);

        (month, day) = calendar.getDate(Holiday.WASHINGTONS_BIRTHDAY, 2025);
        assertEq(month, 2);
        assertEq(day, 17);

        (month, day) = calendar.getDate(Holiday.GOOD_FRIDAY, 2025);
        assertEq(month, 4);
        assertEq(day, 18);

        (month, day) = calendar.getDate(Holiday.MEMORIAL_DAY, 2025);
        assertEq(month, 5);
        assertEq(day, 26);

        (month, day) = calendar.getDate(Holiday.JUNETEENTH_NATIONAL_INDEPENDENCE_DAY, 2025);
        assertEq(month, 6);
        assertEq(day, 19);

        (month, day) = calendar.getDate(Holiday.INDEPENDENCE_DAY, 2025);
        assertEq(month, 7);
        assertEq(day, 4);

        (month, day) = calendar.getDate(Holiday.LABOR_DAY, 2025);
        assertEq(month, 9);
        assertEq(day, 1);

        (month, day) = calendar.getDate(Holiday.THANKSGIVING_DAY, 2025);
        assertEq(month, 11);
        assertEq(day, 27);

        (month, day) = calendar.getDate(Holiday.CHRISTMAS_DAY, 2025);
        assertEq(month, 12);
        assertEq(day, 25);
    }

    function test_allDates2023() public {
        (uint256[10] memory months, uint256[10] memory dates) = calendar.getAllDates(2023);
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
    }

    function test_isHoliday() public {
        assertEq(calendar.isHoliday(2023, 1, 2), true);
        assertEq(calendar.isHoliday(2024, 3, 29), true);
        assertEq(calendar.isHoliday(2025, 6, 19), true);
        assertEq(calendar.isHoliday(2026, 11, 26), true);
    }
}
