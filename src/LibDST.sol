// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import { DST } from "./DST.sol";

library LibDST {
    /// @notice LibDaylightSavings supports 100 years, from 2023 to 2123.
    ///         Years outside this range revert with this error.
    error YearNotFound();

    /// @dev One byte. Width of leading STOP opcode and encoded pair.
    uint256 private constant ONE_BYTE = 0x1;

    /// @dev Offset copied bytes by 31 bytes, so the 1 byte encoded pair
    //       is laid out at the end of a 32-byte word in scratch space.
    uint256 private constant COPY_OFFSET = 0x1f;

    /// @dev Alias for scratch space memory address.
    uint256 private constant SCRATCH_SPACE = 0x0;

    /// @dev Width of one encoded date in bits.
    uint256 private constant DATE_BIT_WIDTH = 3;

    /// @dev Mask to extract start from an encoded pair.
    ///      0x38 == 0b111000
    uint256 private constant START_BIT_MASK = 0x38;

    /// @dev Mask to extract end from an encoded pair.
    ///      0x7 == 0b000111
    uint256 private constant END_BIT_MASK = 0x7;

    /// @dev Offset to add to start value.
    uint256 private constant START_OFFSET = 8;

    /// @dev Offset to add to end value.
    uint256 private constant END_OFFSET = 1;

    function getDates(DST dst, uint256 year)
        internal
        view
        returns (uint256 start, uint256 end)
    {
        if (year < 2023 || year > 2123) revert YearNotFound();

        assembly ("memory-safe") {
            extcodecopy(
                dst,
                COPY_OFFSET,
                add(ONE_BYTE, mul(sub(year, 2023), ONE_BYTE)),
                ONE_BYTE
            )
            let pair := mload(SCRATCH_SPACE)
            start :=
                add(shr(DATE_BIT_WIDTH, and(pair, START_BIT_MASK)), START_OFFSET)
            end := add(and(pair, END_BIT_MASK), END_OFFSET)
        }
    }

    function isDST(DST dst, uint256 year, uint256 month, uint256 day) internal view returns (bool) {
        (uint256 start, uint256 end) = getDates(dst, year);
        // If it's before March or after November, it's not DST.
        if (month < 3 || month > 11) return false;
        // If it's between March and November, we have to check the day..
        if (month == 3) {
            // If it's March, and the day is on or after the start, it's DST.
            return (day >= start);
        } else if (month < 11) {
            // If the month is between March and November, DST is in effect
            return true;
        } else {
            // It's November. If the day is before the end, it's DST.
            return (day < end);
        }
    }
}
