// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Test,console} from "forge-std/Test.sol";
import {CoinFlip} from "../../src/coinFlip.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/ERC20Mock.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract simpleTest is Test{
    CoinFlip cf;
    ERC20Mock token;

    function setUp()external{
        token = new ERC20Mock();
        cf = new CoinFlip(address(token));

        token.mint(address(cf),200*1e18);
        token.mint(address(this),200*1e18);
    }

    function test_A() public {
        IERC20(token).approve(address(cf),200*1e18);
         for (uint256 i = 0; i < 200; i++) {
            cf.flip(1*1e18,false);
        }
        
        assertGt( IERC20(token).balanceOf(address(cf)),200*1e18);
    }
}