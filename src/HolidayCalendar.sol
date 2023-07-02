// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract HolidayCalendar {
    constructor() {
        bytes memory data = (
            hex"00"   // STOP opcode
            hex"0044302a21d7ad372492ef99" // 2023
            hex"00422f299f576d37248af999" // 2024
            hex"00423428a4974d372486f799" // 2025
            hex"0042332820d72d371c9ef599" // 2026
        );
        assembly {
            return(
                add(data, 0x20),
                mload(data)
            )
        }
    }
}
