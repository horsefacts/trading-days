// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import { DST } from "./DST.sol";

library LibDST {
    /// @notice LibDaylightSavings supports 100 years, from 2023 to 2123.
    ///         Years outside this range revert with this error.
    error YearNotFound();

    /// @dev Size of the leading STOP opcode byte in the data contract.
    uint256 private constant STOP_BYTE = 0x1;

    /// @dev Width of one encoded timestamp pair.
    uint256 private constant ONE_PAIR = 0xa;

    /// @dev Offset copied bytes by 22 bytes, so the 10 byte encoded pair
    //       is laid out at the end of a 32-byte word in scratch space.
    uint256 private constant COPY_OFFSET = 0x16;

    /// @dev Alias for scratch space memory address.
    uint256 private constant SCRATCH_SPACE = 0x0;

    /// @dev Width of one encoded date in bits.
    uint256 private constant DATE_BIT_WIDTH = 40;

    /// @dev Mask to extract upper 40 bits from an encoded pair.
    uint256 private constant START_BIT_MASK = 0xffffffffff0000000000;

    /// @dev Mask to extract lower 40 bits from an encoded pair.
    uint256 private constant END_BIT_MASK = 0xffffffffff;

    function getTimestamps(DST dst, uint256 year)
        internal
        view
        returns (uint256 start, uint256 end)
    {
        if (year < 2023 || year > 2123) revert YearNotFound();

        assembly ("memory-safe") {
            extcodecopy(
                dst,
                COPY_OFFSET,
                add(STOP_BYTE, mul(sub(year, 2023), ONE_PAIR)),
                ONE_PAIR
            )
            let pair := mload(SCRATCH_SPACE)
            start := shr(DATE_BIT_WIDTH, and(pair, START_BIT_MASK))
            end := and(pair, END_BIT_MASK)
        }
    }
}
