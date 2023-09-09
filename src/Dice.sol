// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Dice is ReentrancyGuard{

    error InvalidMultiplier(uint256 max, uint256 min, uint256 multiplier);
    error InvalidNumBets(uint256 maxNumBets);
    error WagerAboveLimit(uint256 wager, uint256 maxWager);
    error RefundFailed();

     function Dice_Play(
        uint256 wager,
        uint32 multiplier,
        address tokenAddress,
        bool isOver,
        uint32 numBets,
        uint256 stopGain,
        uint256 stopLoss
    ) external payable nonReentrant {
        // address msgSender = msgSender();
        if (!(multiplier >= 10421 && multiplier <= 9900000)) {
            revert InvalidMultiplier(9900000, 10421, multiplier);
        }
        if (!(numBets > 0 && numBets <= 100)) {
            revert InvalidNumBets(100);
        }

        _kellyWager(wager, tokenAddress, multiplier);

        IERC20(tokenAddress).transferFrom(msg.sender,address(this),numBets*wager);

        int256 totalValue;
        uint256 payout;
        uint32 i;
        uint256[] memory diceOutcomes = new uint256[](numBets);
        uint256[] memory payouts = new uint256[](numBets);

        uint256 winChance = 99000000000 / multiplier;
        uint256 numberToRollOver = 10000000 - winChance;
        uint256 gamePayout = (multiplier * wager) / 10000;


        for (i = 0; i < numBets; i++) {
            if (totalValue >= int256(stopGain)) {
                break;
            }
            if (totalValue <= -int256(stopLoss)) {
                break;
            }

            diceOutcomes[i] = block.timestamp % 10000000;
            if (diceOutcomes[i] >= numberToRollOver && isOver == true) {
                totalValue += int256(gamePayout - wager);
                payout += gamePayout;
                payouts[i] = gamePayout;
                continue;
            }

            if (diceOutcomes[i] <= winChance && isOver == false) {
                totalValue += int256(gamePayout - wager);
                payout += gamePayout;
                payouts[i] = gamePayout;
                continue;
            }

            totalValue -= int256(wager);
        }

        payout += (numBets - i) * wager;

        // uint256 w = wager;
        // uint32 b= numBets;
        // IERC20(tokenAddress).transferFrom(msg.sender,address(this),b*w);
        
        if (payout != 0) {
            IERC20(tokenAddress).transfer(msg.sender,payout);
        }


    }
        /**
     * @dev calculates the maximum wager allowed based on the bankroll size
     */
    function _kellyWager(
        uint256 wager,
        address tokenAddress,
        uint256 multiplier
    ) internal view {
        uint256 balance;
        if (tokenAddress == address(0)) {
            balance = address(this).balance;
        } else {
            balance = IERC20(tokenAddress).balanceOf(address(this));
        }
        uint256 maxWager = (balance * (11000 - 10890)) / (multiplier - 10000);
        if (wager > maxWager) {
            revert WagerAboveLimit(wager, maxWager);
        }
    }
}