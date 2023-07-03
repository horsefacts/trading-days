// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

import { DaylightSavingsCalendar } from
    "../src/calendars/DaylightSavingsCalendar.sol";
import { DaylightSavingsLibrary } from
    "../src/calendars/DaylightSavingsLibrary.sol";

contract DaylightSavingsTest is Test {
    using DaylightSavingsLibrary for DaylightSavingsCalendar;

    DaylightSavingsCalendar dst = new DaylightSavingsCalendar();

    function test_DST_StartEndTimestamps() public {
        assertDSTStartEndEq(2023, 1678604400, 1699167600);
        assertDSTStartEndEq(2024, 1710054000, 1730617200);
        assertDSTStartEndEq(2025, 1741503600, 1762066800);
        assertDSTStartEndEq(2026, 1772953200, 1793516400);
        assertDSTStartEndEq(2027, 1805007600, 1825570800);
        assertDSTStartEndEq(2028, 1836457200, 1857020400);
        assertDSTStartEndEq(2029, 1867906800, 1888470000);
        assertDSTStartEndEq(2030, 1899356400, 1919919600);
        assertDSTStartEndEq(2031, 1930806000, 1951369200);
        assertDSTStartEndEq(2032, 1962860400, 1983423600);
        assertDSTStartEndEq(2033, 1994310000, 2014873200);
        assertDSTStartEndEq(2034, 2025759600, 2046322800);
        assertDSTStartEndEq(2035, 2057209200, 2077772400);
        assertDSTStartEndEq(2036, 2088658800, 2109222000);
        assertDSTStartEndEq(2037, 2120108400, 2140671600);
        assertDSTStartEndEq(2038, 2152162800, 2172726000);
        assertDSTStartEndEq(2039, 2183612400, 2204175600);
        assertDSTStartEndEq(2040, 2215062000, 2235625200);
        assertDSTStartEndEq(2041, 2246511600, 2267074800);
        assertDSTStartEndEq(2042, 2277961200, 2298524400);
        assertDSTStartEndEq(2043, 2309410800, 2329974000);
        assertDSTStartEndEq(2044, 2341465200, 2362028400);
        assertDSTStartEndEq(2045, 2372914800, 2393478000);
        assertDSTStartEndEq(2046, 2404364400, 2424927600);
        assertDSTStartEndEq(2047, 2435814000, 2456377200);
        assertDSTStartEndEq(2048, 2467263600, 2487826800);
        assertDSTStartEndEq(2049, 2499318000, 2519881200);
        assertDSTStartEndEq(2050, 2530767600, 2551330800);
        assertDSTStartEndEq(2051, 2562217200, 2582780400);
        assertDSTStartEndEq(2052, 2593666800, 2614230000);
        assertDSTStartEndEq(2053, 2625116400, 2645679600);
        assertDSTStartEndEq(2054, 2656566000, 2677129200);
        assertDSTStartEndEq(2055, 2688620400, 2709183600);
        assertDSTStartEndEq(2056, 2720070000, 2740633200);
        assertDSTStartEndEq(2057, 2751519600, 2772082800);
        assertDSTStartEndEq(2058, 2782969200, 2803532400);
        assertDSTStartEndEq(2059, 2814418800, 2834982000);
        assertDSTStartEndEq(2060, 2846473200, 2867036400);
        assertDSTStartEndEq(2061, 2877922800, 2898486000);
        assertDSTStartEndEq(2062, 2909372400, 2929935600);
        assertDSTStartEndEq(2063, 2940822000, 2961385200);
        assertDSTStartEndEq(2064, 2972271600, 2992834800);
        assertDSTStartEndEq(2065, 3003721200, 3024284400);
        assertDSTStartEndEq(2066, 3035775600, 3056338800);
        assertDSTStartEndEq(2067, 3067225200, 3087788400);
        assertDSTStartEndEq(2068, 3098674800, 3119238000);
        assertDSTStartEndEq(2069, 3130124400, 3150687600);
        assertDSTStartEndEq(2070, 3161574000, 3182137200);
        assertDSTStartEndEq(2071, 3193023600, 3213586800);
        assertDSTStartEndEq(2072, 3225078000, 3245641200);
        assertDSTStartEndEq(2073, 3256527600, 3277090800);
        assertDSTStartEndEq(2074, 3287977200, 3308540400);
        assertDSTStartEndEq(2075, 3319426800, 3339990000);
        assertDSTStartEndEq(2076, 3350876400, 3371439600);
        assertDSTStartEndEq(2077, 3382930800, 3403494000);
        assertDSTStartEndEq(2078, 3414380400, 3434943600);
        assertDSTStartEndEq(2079, 3445830000, 3466393200);
        assertDSTStartEndEq(2080, 3477279600, 3497842800);
        assertDSTStartEndEq(2081, 3508729200, 3529292400);
        assertDSTStartEndEq(2082, 3540178800, 3560742000);
        assertDSTStartEndEq(2083, 3572233200, 3592796400);
        assertDSTStartEndEq(2084, 3603682800, 3624246000);
        assertDSTStartEndEq(2085, 3635132400, 3655695600);
        assertDSTStartEndEq(2086, 3666582000, 3687145200);
        assertDSTStartEndEq(2087, 3698031600, 3718594800);
        assertDSTStartEndEq(2088, 3730086000, 3750649200);
        assertDSTStartEndEq(2089, 3761535600, 3782098800);
        assertDSTStartEndEq(2090, 3792985200, 3813548400);
        assertDSTStartEndEq(2091, 3824434800, 3844998000);
        assertDSTStartEndEq(2092, 3855884400, 3876447600);
        assertDSTStartEndEq(2093, 3887334000, 3907897200);
        assertDSTStartEndEq(2094, 3919388400, 3939951600);
        assertDSTStartEndEq(2095, 3950838000, 3971401200);
        assertDSTStartEndEq(2096, 3982287600, 4002850800);
        assertDSTStartEndEq(2097, 4013737200, 4034300400);
        assertDSTStartEndEq(2098, 4045186800, 4065750000);
        assertDSTStartEndEq(2099, 4076636400, 4097199600);
        assertDSTStartEndEq(2100, 4108690800, 4129254000);
        assertDSTStartEndEq(2101, 4140140400, 4160703600);
        assertDSTStartEndEq(2102, 4171590000, 4192153200);
        assertDSTStartEndEq(2103, 4203039600, 4223602800);
        assertDSTStartEndEq(2104, 4234489200, 4255052400);
        assertDSTStartEndEq(2105, 4265938800, 4286502000);
        assertDSTStartEndEq(2106, 4297993200, 4318556400);
        assertDSTStartEndEq(2107, 4329442800, 4350006000);
        assertDSTStartEndEq(2108, 4360892400, 4381455600);
        assertDSTStartEndEq(2109, 4392342000, 4412905200);
        assertDSTStartEndEq(2110, 4423791600, 4444354800);
        assertDSTStartEndEq(2111, 4455241200, 4475804400);
        assertDSTStartEndEq(2112, 4487295600, 4507858800);
        assertDSTStartEndEq(2113, 4518745200, 4539308400);
        assertDSTStartEndEq(2114, 4550194800, 4570758000);
        assertDSTStartEndEq(2115, 4581644400, 4602207600);
        assertDSTStartEndEq(2116, 4613094000, 4633657200);
        assertDSTStartEndEq(2117, 4645148400, 4665711600);
        assertDSTStartEndEq(2118, 4676598000, 4697161200);
        assertDSTStartEndEq(2119, 4708047600, 4728610800);
        assertDSTStartEndEq(2120, 4739497200, 4760060400);
        assertDSTStartEndEq(2121, 4770946800, 4791510000);
        assertDSTStartEndEq(2122, 4802396400, 4822959600);
        assertDSTStartEndEq(2123, 4834450800, 4855014000);
    }

    function assertDSTStartEndEq(uint256 year, uint256 s, uint256 e) internal {
        (uint256 start, uint256 end) = dst.getTimestamps(year);
        assertEq(s, start);
        assertEq(e, end);
    }
}
