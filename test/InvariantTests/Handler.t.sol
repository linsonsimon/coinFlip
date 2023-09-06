// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {CommonBase} from "forge-std/Base.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {StdUtils} from "forge-std/StdUtils.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/ERC20Mock.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {CoinFlip} from "../../src/coinFlip.sol";

contract Handler is CommonBase, StdCheats, StdUtils {
    ERC20Mock private token;
    CoinFlip coinflip;
    // uint256 public tokenBalance;
    uint256 public numCalls;

    constructor(ERC20Mock _token,CoinFlip _coinflip) {
        token = _token;
        coinflip=_coinflip;
    }

    function flip(uint wager, bool isHeads) public{
        numCalls+=1;
        uint256 balance = IERC20(token).balanceOf(address(coinflip));
        wager = bound(wager,0,(balance * 1122448) / 100000000);
        IERC20(token).approve(address(coinflip),100*1e18);

        
        vm.warp(block.timestamp);
        coinflip.flip(wager,isHeads);
    }

}