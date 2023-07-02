// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

/// @notice Data contract encoding Daylight Savings start/end dates.
contract DST {
    constructor() {
        bytes memory data = (
            hex"00" // STOP opcode
            hex"2412090036241b1209362d241b0900362d1b1209002d241b1200362d241209"
            hex"0036241b1209362d241b0900362d1b1209002d241b1200362d241209003624"
            hex"1b1209362d241b0900362d1b120900362d241b0900362d1b1209002d241b12"
            hex"00362d2412090036"
        );
        assembly {
            return(add(data, 0x20), mload(data))
        }
    }
}
