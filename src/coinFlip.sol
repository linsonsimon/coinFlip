// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CoinFlip{

    address public token;

    event Toss(uint,uint);

    constructor(address _token){
        token = _token;
    }

    function flip(uint wager,bool isHeads) external{
        _kellyWager(wager);
        IERC20(token).transferFrom(msg.sender,address(this),wager);
        uint toss = block.timestamp % 2;
        uint payOut;
        if(toss ==1 && isHeads ==true){
            payOut = (wager * 19800/10000);
        }
        if(toss ==0 && isHeads ==false){
            payOut = (wager * 19800/10000);
        }
        IERC20(token).transfer(msg.sender,payOut);
        emit Toss(toss,payOut);
    }

    function _kellyWager(uint256 wager) internal view {
        uint256 balance = IERC20(token).balanceOf(address(this));
        uint256 maxWager = (balance * 1122448) / 100000000;
        require(wager <= maxWager,"Wager above limit");
    }
}