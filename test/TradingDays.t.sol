// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import { GasSnapshot } from "forge-gas-snapshot/GasSnapshot.sol";
import { TestERC20 } from "@uniswap/v4-core/contracts/test/TestERC20.sol";
import { IERC20Minimal } from
    "@uniswap/v4-core/contracts/interfaces/external/IERC20Minimal.sol";
import { IHooks } from "@uniswap/v4-core/contracts/interfaces/IHooks.sol";
import { Hooks } from "@uniswap/v4-core/contracts/libraries/Hooks.sol";
import { TickMath } from "@uniswap/v4-core/contracts/libraries/TickMath.sol";
import { PoolManager } from "@uniswap/v4-core/contracts/PoolManager.sol";
import { IPoolManager } from
    "@uniswap/v4-core/contracts/interfaces/IPoolManager.sol";
import { PoolId } from "@uniswap/v4-core/contracts/libraries/PoolId.sol";
import { PoolModifyPositionTest } from
    "@uniswap/v4-core/contracts/test/PoolModifyPositionTest.sol";
import { PoolSwapTest } from "@uniswap/v4-core/contracts/test/PoolSwapTest.sol";
import { PoolDonateTest } from
    "@uniswap/v4-core/contracts/test/PoolDonateTest.sol";
import { Deployers } from
    "@uniswap/v4-core/test/foundry-tests/utils/Deployers.sol";
import {
    CurrencyLibrary,
    Currency
} from "@uniswap/v4-core/contracts/libraries/CurrencyLibrary.sol";
import { BokkyPooBahsDateTimeLibrary as LibDateTime } from
    "BokkyPooBahsDateTimeLibrary/contracts/BokkyPooBahsDateTimeLibrary.sol";

import { TradingDaysHook } from "../src/TradingDaysHook.sol";
import { TradingDays } from "../src/TradingDays.sol";
import { TradingDaysImplementation } from
    "../src/implementation/TradingDaysImplementation.sol";
import { Holiday } from "../src/calendars/HolidaysLibrary.sol";
import { HolidayCalendar } from "../src/calendars/HolidayCalendar.sol";
import { DaylightSavingsCalendar } from
    "../src/calendars/DaylightSavingsCalendar.sol";

contract TradingDaysTest is Test, Deployers, GasSnapshot {
    using LibDateTime for uint256;
    using PoolId for IPoolManager.PoolKey;
    using CurrencyLibrary for Currency;

    event DingDingDing(address indexed ringer);

    TradingDaysHook tradingDays =
        TradingDaysHook(address(uint160(Hooks.BEFORE_SWAP_FLAG)));
    PoolManager manager;
    PoolModifyPositionTest modifyPositionRouter;
    PoolSwapTest swapRouter;
    TestERC20 token0;
    TestERC20 token1;
    IPoolManager.PoolKey poolKey;
    bytes32 poolId;

    HolidayCalendar holidays = new HolidayCalendar();
    DaylightSavingsCalendar dst = new DaylightSavingsCalendar();

    function setUp() public {
        token0 = new TestERC20(2**128);
        token1 = new TestERC20(2**128);
        manager = new PoolManager(500000);

        // Testing environment requires our contract to override
        // `validateHookAddress`.
        // We do that via the Implementation contract to avoid deploying the
        // override with the production contract
        TradingDaysImplementation impl =
        new TradingDaysImplementation(manager, holidays, dst, tradingDays);
        (, bytes32[] memory writes) = vm.accesses(address(impl));
        vm.etch(address(tradingDays), address(impl).code);

        // for each storage key that was written during the hook implementation,
        // copy the value over
        unchecked {
            for (uint256 i = 0; i < writes.length; i++) {
                bytes32 slot = writes[i];
                vm.store(
                    address(tradingDays), slot, vm.load(address(impl), slot)
                );
            }
        }

        // Create the pool
        poolKey = IPoolManager.PoolKey(
            Currency.wrap(address(token0)),
            Currency.wrap(address(token1)),
            3000,
            60,
            IHooks(tradingDays)
        );
        poolId = PoolId.toId(poolKey);
        manager.initialize(poolKey, SQRT_RATIO_1_1);

        // Helpers for interacting with the pool
        modifyPositionRouter =
            new PoolModifyPositionTest(IPoolManager(address(manager)));
        swapRouter = new PoolSwapTest(IPoolManager(address(manager)));

        // Provide liquidity to the pool
        token0.approve(address(modifyPositionRouter), 100 ether);
        token1.approve(address(modifyPositionRouter), 100 ether);
        token0.mint(address(this), 100 ether);
        token1.mint(address(this), 100 ether);
        modifyPositionRouter.modifyPosition(
            poolKey, IPoolManager.ModifyPositionParams(-60, 60, 10 ether)
        );
        modifyPositionRouter.modifyPosition(
            poolKey, IPoolManager.ModifyPositionParams(-120, 120, 10 ether)
        );
        modifyPositionRouter.modifyPosition(
            poolKey,
            IPoolManager.ModifyPositionParams(
                TickMath.minUsableTick(60), TickMath.maxUsableTick(60), 10 ether
            )
        );

        // Approve for swapping
        token0.approve(address(swapRouter), 100 ether);
        token1.approve(address(swapRouter), 100 ether);
    }

    function test_BeforeOpeningBellReverts_AfterHours() public {
        uint256 JUN_5_2023_9_29_29_ET = 1685971769;
        vm.warp(JUN_5_2023_9_29_29_ET);

        // Perform a test swap //
        IPoolManager.SwapParams memory params = IPoolManager.SwapParams({
            zeroForOne: true,
            amountSpecified: 100,
            sqrtPriceLimitX96: SQRT_RATIO_1_2
        });

        PoolSwapTest.TestSettings memory testSettings = PoolSwapTest
            .TestSettings({ withdrawTokens: true, settleUsingTransfer: true });

        vm.expectRevert(TradingDays.AfterHours.selector);
        swapRouter.swap(poolKey, params, testSettings);
    }

    function test_AfterOpeningBellReverts_AfterHours() public {
        uint256 JUN_5_2023_16_00_00_ET = 1685995200;
        vm.warp(JUN_5_2023_16_00_00_ET);

        // Perform a test swap //
        IPoolManager.SwapParams memory params = IPoolManager.SwapParams({
            zeroForOne: true,
            amountSpecified: 100,
            sqrtPriceLimitX96: SQRT_RATIO_1_2
        });

        PoolSwapTest.TestSettings memory testSettings = PoolSwapTest
            .TestSettings({ withdrawTokens: true, settleUsingTransfer: true });

        vm.expectRevert(TradingDays.AfterHours.selector);
        swapRouter.swap(poolKey, params, testSettings);
    }

    function test_WeekendReverts_ClosedForWeekend() public {
        uint256 JUN_4_2023_11_00_ET = 1685890800;
        vm.warp(JUN_4_2023_11_00_ET);

        // Perform a test swap //
        IPoolManager.SwapParams memory params = IPoolManager.SwapParams({
            zeroForOne: true,
            amountSpecified: 100,
            sqrtPriceLimitX96: SQRT_RATIO_1_2
        });

        PoolSwapTest.TestSettings memory testSettings = PoolSwapTest
            .TestSettings({ withdrawTokens: true, settleUsingTransfer: true });

        vm.expectRevert(TradingDays.ClosedForWeekend.selector);
        swapRouter.swap(poolKey, params, testSettings);
    }

    function test_EdgeCase_SecondBeforeHoliday_EDT() public {
        uint256 SEP_4_2023_00_00_00_ET = 1693800000;
        vm.warp(SEP_4_2023_00_00_00_ET - 1);

        // Perform a test swap //
        IPoolManager.SwapParams memory params = IPoolManager.SwapParams({
            zeroForOne: true,
            amountSpecified: 100,
            sqrtPriceLimitX96: SQRT_RATIO_1_2
        });

        PoolSwapTest.TestSettings memory testSettings = PoolSwapTest
            .TestSettings({ withdrawTokens: true, settleUsingTransfer: true });

        vm.expectRevert(TradingDays.ClosedForWeekend.selector);
        swapRouter.swap(poolKey, params, testSettings);
    }

    function test_EdgeCase_SecondAfterHoliday_EDT() public {
        uint256 SEP_4_2023_23_59_59_ET = 1693886399;
        vm.warp(SEP_4_2023_23_59_59_ET + 1);

        // Perform a test swap //
        IPoolManager.SwapParams memory params = IPoolManager.SwapParams({
            zeroForOne: true,
            amountSpecified: 100,
            sqrtPriceLimitX96: SQRT_RATIO_1_2
        });

        PoolSwapTest.TestSettings memory testSettings = PoolSwapTest
            .TestSettings({ withdrawTokens: true, settleUsingTransfer: true });

        vm.expectRevert(TradingDays.AfterHours.selector);
        swapRouter.swap(poolKey, params, testSettings);
    }

    function test_EdgeCase_SecondBeforeHoliday_EST() public {
        uint256 DEC_25_2024_00_00_00_ET = 1735102800;
        vm.warp(DEC_25_2024_00_00_00_ET - 1);

        // Perform a test swap //
        IPoolManager.SwapParams memory params = IPoolManager.SwapParams({
            zeroForOne: true,
            amountSpecified: 100,
            sqrtPriceLimitX96: SQRT_RATIO_1_2
        });

        PoolSwapTest.TestSettings memory testSettings = PoolSwapTest
            .TestSettings({ withdrawTokens: true, settleUsingTransfer: true });

        vm.expectRevert(TradingDays.AfterHours.selector);
        swapRouter.swap(poolKey, params, testSettings);
    }

    function test_EdgeCase_SecondAfterHoliday_EST() public {
        uint256 DEC_25_2024_23_59_59_ET = 1735189199;
        vm.warp(DEC_25_2024_23_59_59_ET + 1);

        // Perform a test swap //
        IPoolManager.SwapParams memory params = IPoolManager.SwapParams({
            zeroForOne: true,
            amountSpecified: 100,
            sqrtPriceLimitX96: SQRT_RATIO_1_2
        });

        PoolSwapTest.TestSettings memory testSettings = PoolSwapTest
            .TestSettings({ withdrawTokens: true, settleUsingTransfer: true });

        vm.expectRevert(TradingDays.AfterHours.selector);
        swapRouter.swap(poolKey, params, testSettings);
    }

    function test_HolidayReverts_ClosedForHoliday() public {
        uint256 SEP_4_2023_11_00_ET = 1693839600;
        vm.warp(SEP_4_2023_11_00_ET);

        // Perform a test swap //
        IPoolManager.SwapParams memory params = IPoolManager.SwapParams({
            zeroForOne: true,
            amountSpecified: 100,
            sqrtPriceLimitX96: SQRT_RATIO_1_2
        });

        PoolSwapTest.TestSettings memory testSettings = PoolSwapTest
            .TestSettings({ withdrawTokens: true, settleUsingTransfer: true });

        bytes memory expectedError = abi.encodeWithSelector(
            TradingDays.ClosedForHoliday.selector, Holiday.LABOR_DAY
        );
        vm.expectRevert(expectedError);
        swapRouter.swap(poolKey, params, testSettings);
    }

    function test_HolidayReverts_ClosedForHoliday_AccountsForTimezone_EDT()
        public
    {
        uint256 SEP_4_2023_23_59_59_ET = 1693886399;
        vm.warp(SEP_4_2023_23_59_59_ET);

        // Perform a test swap //
        IPoolManager.SwapParams memory params = IPoolManager.SwapParams({
            zeroForOne: true,
            amountSpecified: 100,
            sqrtPriceLimitX96: SQRT_RATIO_1_2
        });

        PoolSwapTest.TestSettings memory testSettings = PoolSwapTest
            .TestSettings({ withdrawTokens: true, settleUsingTransfer: true });

        bytes memory expectedError = abi.encodeWithSelector(
            TradingDays.ClosedForHoliday.selector, Holiday.LABOR_DAY
        );
        vm.expectRevert(expectedError);
        swapRouter.swap(poolKey, params, testSettings);
    }

    function test_HolidayReverts_ClosedForHoliday_AccountsForTimezone_EST()
        public
    {
        uint256 NOV_23_2023_23_59_59_ET = 1700801999;
        vm.warp(NOV_23_2023_23_59_59_ET);

        // Perform a test swap //
        IPoolManager.SwapParams memory params = IPoolManager.SwapParams({
            zeroForOne: true,
            amountSpecified: 100,
            sqrtPriceLimitX96: SQRT_RATIO_1_2
        });

        PoolSwapTest.TestSettings memory testSettings = PoolSwapTest
            .TestSettings({ withdrawTokens: true, settleUsingTransfer: true });

        bytes memory expectedError = abi.encodeWithSelector(
            TradingDays.ClosedForHoliday.selector, Holiday.THANKSGIVING_DAY
        );
        vm.expectRevert(expectedError);
        swapRouter.swap(poolKey, params, testSettings);
    }

    function test_SwapsAllowedDuringCoreTradingHours() public {
        uint256 JUN_5_2023_11_30_ET = 1685979000;
        vm.warp(JUN_5_2023_11_30_ET);

        // Perform a test swap //
        IPoolManager.SwapParams memory params = IPoolManager.SwapParams({
            zeroForOne: true,
            amountSpecified: 100,
            sqrtPriceLimitX96: SQRT_RATIO_1_2
        });

        PoolSwapTest.TestSettings memory testSettings = PoolSwapTest
            .TestSettings({ withdrawTokens: true, settleUsingTransfer: true });

        swapRouter.swap(poolKey, params, testSettings);
    }

    function test_SwapsAllowedDuringCoreTradingHours_StartInclusive() public {
        uint256 JUN_5_2023_9_30_ET = 1685971800;
        vm.warp(JUN_5_2023_9_30_ET);

        // Perform a test swap //
        IPoolManager.SwapParams memory params = IPoolManager.SwapParams({
            zeroForOne: true,
            amountSpecified: 100,
            sqrtPriceLimitX96: SQRT_RATIO_1_2
        });

        PoolSwapTest.TestSettings memory testSettings = PoolSwapTest
            .TestSettings({ withdrawTokens: true, settleUsingTransfer: true });

        swapRouter.swap(poolKey, params, testSettings);
    }

    function test_SwapsAllowedDuringCoreTradingHours_CloseExclusive() public {
        uint256 AUG_14_2023_16_00_ET = 1692043200;
        vm.warp(AUG_14_2023_16_00_ET);

        // Perform a test swap //
        IPoolManager.SwapParams memory params = IPoolManager.SwapParams({
            zeroForOne: true,
            amountSpecified: 100,
            sqrtPriceLimitX96: SQRT_RATIO_1_2
        });

        PoolSwapTest.TestSettings memory testSettings = PoolSwapTest
            .TestSettings({ withdrawTokens: true, settleUsingTransfer: true });

        vm.expectRevert(TradingDays.AfterHours.selector);
        swapRouter.swap(poolKey, params, testSettings);
    }

    function test_FirstSwapRingsOpeningBell() public {
        uint256 JUN_5_2023_11_30_ET = 1685979000;
        vm.warp(JUN_5_2023_11_30_ET);

        // Perform a test swap //
        IPoolManager.SwapParams memory params = IPoolManager.SwapParams({
            zeroForOne: true,
            amountSpecified: 100,
            sqrtPriceLimitX96: SQRT_RATIO_1_2
        });

        PoolSwapTest.TestSettings memory testSettings = PoolSwapTest
            .TestSettings({ withdrawTokens: true, settleUsingTransfer: true });

        vm.expectEmit(true, false, false, true);
        emit DingDingDing(address(swapRouter));

        swapRouter.swap(poolKey, params, testSettings);
        assertEq(tradingDays.marketOpened(2023, 6, 5), true);
    }

    function test_SubsequentSwapsDoNotRingOpeningBell() public {
        uint256 JUN_5_2023_11_30_ET = 1685979000;
        vm.warp(JUN_5_2023_11_30_ET);

        // Perform a test swap //
        IPoolManager.SwapParams memory params = IPoolManager.SwapParams({
            zeroForOne: true,
            amountSpecified: 100,
            sqrtPriceLimitX96: SQRT_RATIO_1_2
        });

        PoolSwapTest.TestSettings memory testSettings = PoolSwapTest
            .TestSettings({ withdrawTokens: true, settleUsingTransfer: true });

        vm.expectEmit(true, false, false, true);
        emit DingDingDing(address(swapRouter));

        swapRouter.swap(poolKey, params, testSettings);
        assertEq(tradingDays.marketOpened(2023, 6, 5), true);

        vm.recordLogs();

        swapRouter.swap(poolKey, params, testSettings);

        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries.length, 3);

        // DingDingDing(address) does not appear.
        assertEq(
            entries[0].topics[0],
            keccak256(
                "Swap(bytes32,address,int128,int128,uint160,uint128,int24,uint24)"
            )
        );
        assertEq(
            entries[1].topics[0], keccak256("Transfer(address,address,uint256)")
        );
        assertEq(
            entries[2].topics[0], keccak256("Transfer(address,address,uint256)")
        );
    }
}
