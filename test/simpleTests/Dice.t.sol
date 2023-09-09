// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Test,console} from "forge-std/Test.sol";
import {Dice} from "../../src/Dice.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/ERC20Mock.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract diceSimpleTest is Test{
    Dice dice;
    ERC20Mock token;

    function setUp()external{
        token = new ERC20Mock();
        dice = new Dice();

        token.mint(address(dice),1000*1e18);
        token.mint(address(this),200*1e18);
    }

    function test_dice() public {
        IERC20(token).approve(address(dice),200*1e18);
        // vm.warp(block.timestamp);
         

        dice.Dice_Play(1*1e18,99000,address(token),false,100,50*1e18,50*1e18);

        uint256 b1 =IERC20(token).balanceOf(address(dice));
        
        assertGt( b1,1000*1e18);

        // for (uint256 i = 0; i < 100; i++) {
        //     cf.flip(1*1e18,false);
        // }

        // uint256 b2 =IERC20(token).balanceOf(address(cf));
        
        // assertGt( b2,b1);
    }
}