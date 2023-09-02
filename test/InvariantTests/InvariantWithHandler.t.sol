// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {Handler} from "./Handler.t.sol";
import {CoinFlip} from "../../src/coinFlip.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/ERC20Mock.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract COIN_FLIP_Invariant_Tests is StdInvariant, Test {
    CoinFlip cf;
    ERC20Mock token;
    Handler public handler;

    function setUp() public {
        token = new ERC20Mock();
        cf = new CoinFlip(address(token));
        handler = new Handler(token,cf);

        token.mint(address(cf),200*1e18);
        token.mint(address(this),100*1e18);
        
        // Send 100 ETH to handler
        deal(address(this), 100 * 1e18);
        deal(address(cf), 100 * 1e18);
        // Set fuzzer to only call the handler
        targetContract(address(handler));

        bytes4[] memory selectors = new bytes4[](1);
        selectors[0] = Handler.flip.selector;

        targetSelector(
            FuzzSelector({addr: address(handler), selectors: selectors})
        );
    }

    function invariant_token_balance() public {
        assertGt( IERC20(token).balanceOf(address(cf)),200*1e18);
        console.log("handler num calls", handler.numCalls());
    }
}