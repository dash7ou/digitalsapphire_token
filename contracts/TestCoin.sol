// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TestCoin is ERC20 {
    uint8 public tokenDecimals = 18;
    uint256 public tSupply = 10000000000 * 10 ** tokenDecimals; // 10B tokens

    constructor() ERC20("Dollar", "USDT") {
        _mint(msg.sender, tSupply);
    }
}