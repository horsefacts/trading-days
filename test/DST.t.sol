// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

import { DST } from "../src/DST.sol";
import { LibDST } from "../src/LibDST.sol";

contract DSTTest is Test {
    using LibDST for DST;

    DST dst = new DST();

    function test_DST_StartEndDates() public {
        assertDSTStartEndEq(2023, 12, 5);
        assertDSTStartEndEq(2024, 10, 3);
        assertDSTStartEndEq(2025, 9, 2);
        assertDSTStartEndEq(2026, 8, 1);
        assertDSTStartEndEq(2027, 14, 7);
        assertDSTStartEndEq(2028, 12, 5);
        assertDSTStartEndEq(2029, 11, 4);
        assertDSTStartEndEq(2030, 10, 3);
        assertDSTStartEndEq(2031, 9, 2);
        assertDSTStartEndEq(2032, 14, 7);
        assertDSTStartEndEq(2033, 13, 6);
        assertDSTStartEndEq(2034, 12, 5);
        assertDSTStartEndEq(2035, 11, 4);
        assertDSTStartEndEq(2036, 9, 2);
        assertDSTStartEndEq(2037, 8, 1);
        assertDSTStartEndEq(2038, 14, 7);
        assertDSTStartEndEq(2039, 13, 6);
        assertDSTStartEndEq(2040, 11, 4);
        assertDSTStartEndEq(2041, 10, 3);
        assertDSTStartEndEq(2042, 9, 2);
        assertDSTStartEndEq(2043, 8, 1);
        assertDSTStartEndEq(2044, 13, 6);
        assertDSTStartEndEq(2045, 12, 5);
        assertDSTStartEndEq(2046, 11, 4);
        assertDSTStartEndEq(2047, 10, 3);
        assertDSTStartEndEq(2048, 8, 1);
        assertDSTStartEndEq(2049, 14, 7);
        assertDSTStartEndEq(2050, 13, 6);
        assertDSTStartEndEq(2051, 12, 5);
        assertDSTStartEndEq(2052, 10, 3);
        assertDSTStartEndEq(2053, 9, 2);
        assertDSTStartEndEq(2054, 8, 1);
        assertDSTStartEndEq(2055, 14, 7);
        assertDSTStartEndEq(2056, 12, 5);
        assertDSTStartEndEq(2057, 11, 4);
        assertDSTStartEndEq(2058, 10, 3);
        assertDSTStartEndEq(2059, 9, 2);
        assertDSTStartEndEq(2060, 14, 7);
        assertDSTStartEndEq(2061, 13, 6);
        assertDSTStartEndEq(2062, 12, 5);
        assertDSTStartEndEq(2063, 11, 4);
        assertDSTStartEndEq(2064, 9, 2);
        assertDSTStartEndEq(2065, 8, 1);
        assertDSTStartEndEq(2066, 14, 7);
        assertDSTStartEndEq(2067, 13, 6);
        assertDSTStartEndEq(2068, 11, 4);
        assertDSTStartEndEq(2069, 10, 3);
        assertDSTStartEndEq(2070, 9, 2);
        assertDSTStartEndEq(2071, 8, 1);
        assertDSTStartEndEq(2072, 13, 6);
        assertDSTStartEndEq(2073, 12, 5);
        assertDSTStartEndEq(2074, 11, 4);
        assertDSTStartEndEq(2075, 10, 3);
        assertDSTStartEndEq(2076, 8, 1);
        assertDSTStartEndEq(2077, 14, 7);
        assertDSTStartEndEq(2078, 13, 6);
        assertDSTStartEndEq(2079, 12, 5);
        assertDSTStartEndEq(2080, 10, 3);
        assertDSTStartEndEq(2081, 9, 2);
        assertDSTStartEndEq(2082, 8, 1);
        assertDSTStartEndEq(2083, 14, 7);
        assertDSTStartEndEq(2084, 12, 5);
        assertDSTStartEndEq(2085, 11, 4);
        assertDSTStartEndEq(2086, 10, 3);
        assertDSTStartEndEq(2087, 9, 2);
        assertDSTStartEndEq(2088, 14, 7);
        assertDSTStartEndEq(2089, 13, 6);
        assertDSTStartEndEq(2090, 12, 5);
        assertDSTStartEndEq(2091, 11, 4);
        assertDSTStartEndEq(2092, 9, 2);
        assertDSTStartEndEq(2093, 8, 1);
        assertDSTStartEndEq(2094, 14, 7);
        assertDSTStartEndEq(2095, 13, 6);
        assertDSTStartEndEq(2096, 11, 4);
        assertDSTStartEndEq(2097, 10, 3);
        assertDSTStartEndEq(2098, 9, 2);
        assertDSTStartEndEq(2099, 8, 1);
        assertDSTStartEndEq(2100, 14, 7);
        assertDSTStartEndEq(2101, 13, 6);
        assertDSTStartEndEq(2102, 12, 5);
        assertDSTStartEndEq(2103, 11, 4);
        assertDSTStartEndEq(2104, 9, 2);
        assertDSTStartEndEq(2105, 8, 1);
        assertDSTStartEndEq(2106, 14, 7);
        assertDSTStartEndEq(2107, 13, 6);
        assertDSTStartEndEq(2108, 11, 4);
        assertDSTStartEndEq(2109, 10, 3);
        assertDSTStartEndEq(2110, 9, 2);
        assertDSTStartEndEq(2111, 8, 1);
        assertDSTStartEndEq(2112, 13, 6);
        assertDSTStartEndEq(2113, 12, 5);
        assertDSTStartEndEq(2114, 11, 4);
        assertDSTStartEndEq(2115, 10, 3);
        assertDSTStartEndEq(2116, 8, 1);
        assertDSTStartEndEq(2117, 14, 7);
        assertDSTStartEndEq(2118, 13, 6);
        assertDSTStartEndEq(2119, 12, 5);
        assertDSTStartEndEq(2120, 10, 3);
        assertDSTStartEndEq(2121, 9, 2);
        assertDSTStartEndEq(2122, 8, 1);
        assertDSTStartEndEq(2123, 14, 7);
    }

    function test_isDST() public {
        assertEq(dst.isDST(2023, 1, 15), false);

        assertEq(dst.isDST(2023, 3, 11), false);
        assertEq(dst.isDST(2023, 3, 12), true);
        assertEq(dst.isDST(2023, 3, 13), true);

        assertEq(dst.isDST(2023, 6, 15), true);

        assertEq(dst.isDST(2023, 11, 3), true);
        assertEq(dst.isDST(2023, 11, 4), true);
        assertEq(dst.isDST(2023, 11, 5), false);

        assertEq(dst.isDST(2023, 12, 4), false);
    }

    function assertDSTStartEndEq(uint256 year, uint256 s, uint256 e) internal {
        (uint256 start, uint256 end) = dst.getDates(year);
        assertEq(s, start);
        assertEq(e, end);
    }
}
