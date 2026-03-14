// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./erc20.sol";

contract AirportContract {
    string private _name;
    string private _symbol;

    ERC20Simple public _token;

    uint256 private _totalSupply;
    
    mapping(address => uint256) private _balances;

    constructor() {
        _token = new ERC20Simple("Mi token", "token", 5, 0);
    }

    function getToken() external view returns (ERC20Simple) {
        return _token;
    }
}