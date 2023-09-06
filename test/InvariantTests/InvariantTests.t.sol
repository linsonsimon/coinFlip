// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {CoinFlip} from "../../src/coinFlip.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/ERC20Mock.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract COIN_FLIP_Invariant_Tests is StdInvariant, Test {
    CoinFlip cf;
    ERC20Mock token;
    // Handler public handler;

    function setUp() public {
        token = new ERC20Mock();
        cf = new CoinFlip(address(token));


        token.mint(address(cf),200*1e18);
        token.mint(address(this),100*1e18);
        
        // Send 100 ETH to handler
        deal(address(this), 100 * 1e18);
        deal(address(cf), 100 * 1e18);
        IERC20(token).approve(address(cf),100*1e18);
        // Set fuzzer to only call the coinFlip
        targetContract(address(cf));
    }

    function invariant_basic_balance() public {
        // IERC20(token).approve(address(cf),100*1e18);
        //  for (uint256 i = 0; i < 100; i++) {
        //     cf.flip(1*1e18,false);
        // }
        assertGt( IERC20(token).balanceOf(address(cf)),200*1e18);
    }
}