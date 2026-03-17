// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./erc20.sol";

contract AirportContract is ERC20Simple {
    string private _name;
    ERC20Simple private _token;
    uint256 private _totalSupply;
    address payable public owner;

    struct Passenger {
        address id;
        string name;
    }

    mapping(address => Passenger) private listPassengers;

    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_,
        uint256 initialSupply_
    ) ERC20Simple(name_, symbol_, decimals_, initialSupply_) {
        owner = payable (msg.sender);
    }

    function getToken() external view returns (ERC20Simple) {
        return _token;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    function register(address id_, string memory name_) external onlyOwner  {
        require(listPassengers[id_].id == address(0), "Passenger is already registered");

        Passenger memory passenger = Passenger({
            id: id_,
            balance: 0,
            name: name_
        });

        listPassengers[id_] = passenger;
    }

    function assignToken(address id, uint256 miles) external onlyOwner {
        _token.mint(id, miles);
        listPassengers[id].balance += miles;
    } 

    function burnToken(address id, uint256 miles) external onlyOwner {
        require(listPassengers[id].balance >= miles, "Not enough miles");
        _token.burn(id, miles);
        listPassengers[id].balance -= miles;
    } 
}