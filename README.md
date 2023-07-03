# 🗽 trading-days

![Build Status](https://github.com/horsefacts/trading-days/actions/workflows/.github/workflows/test.yml/badge.svg?branch=main)

A Uniswap v4 hook that reverts when markets are closed in New York.

## Views

- `isCoreTradingHours`: Return `true` between 9:30 AM and 4:00 PM ET.
- `isTradingDay`: Return `true` Mon-Fri, if it's not a NYSE holiday.
- `isHoliday`: Return `true` if it's a NYSE holiday.
- `getHoliday`: Get the current holiday (see the `Holiday` enum).
- `isDST`: Return `true` if it's Daylight Savings Time in New York.
- `time`: Adjust `block.timestamp` so that UTC date calculations are localized to US Eastern Time. Subtracts either 4 or 5 hours, depending on whether it's DST.
- `marketIsOpen`: Return `true` if the market is currently open.
- `state`: Get the current state of the market, one of:
  - `HOLIDAY`
  - `WEEKEND`
  - `AFTER_HOURS`
  - `OPEN`

## Errors

- `ClosedForHoliday(Holiday holiday)`: Markets are closed for a [NYSE holiday](https://www.nyse.com/markets/hours-calendars). Error data includes a Holiday enum, one of:
  - `NEW_YEARS_DAY`
  - `MARTIN_LUTHER_KING_JR_DAY`
  - `WASHINGTONS_BIRTHDAY`
  - `GOOD_FRIDAY`
  - `MEMORIAL_DAY`
  - `JUNETEENTH_NATIONAL_INDEPENDENCE_DAY`
  - `INDEPENDENCE_DAY`
  - `LABOR_DAY`
  - `THANKSGIVING_DAY`
  - `CHRISTMAS_DAY`
  - `NEW_YEARS_DAY_OBSERVED`
- `ClosedForWeekend`: Markets are closed for the weekend.
- `AfterHours`: Markets are closed on weekdays before 9:30 AM and after 4:00 PM ET.

## Events

- `DingDingDing`: If you perform the first swap of the day, you get to ring the opening bell!

## Technical Details

The NYSE holiday calendar and Daylight Savings start/end timestamps are stored as [data contracts](https://github.com/dragonfly-xyz/useful-solidity-patterns/tree/main/patterns/big-data-storage).

NYSE holidays were precalculated through 2123 using the Python [holidays](https://pypi.org/project/holidays/) package. Each 13-byte sequence encodes one year, which includes up to 11 holidays. Each holiday is encoded as 9 bits, 4 for the month and 5 for the day. A year may have 9, 10, or 11 holidays, depending on whether New Year's Day of the next year falls on a Saturday.

The start and end timestamps for Daylight Savings were precalculated through 2123 using the `calculate_dst.py` script in this repo. The data contract stores each start/end pair as an 8-byte sequence, encoding two 32-bit values representing seconds since Jan 1, 2023. These represent the exact start and end timestamp of Daylight Savings Time in New York, according to current [DST rules](https://www.nist.gov/pml/time-and-frequency-division/popular-links/daylight-saving-time-dst). (That is, DST starts at 2am local time on the second Sunday of March and ends 2am local time on the first Sunday of November).

## Acknowledgments

Inspired by [Mariano's](https://github.com/nanexcool) legendary "office hours" modifier:

<a href="https://twitter.com/nanexcool/status/1259623747339849729" target="_blank">
  <img src="./img/office_hours.png" width=480px />
</a>
