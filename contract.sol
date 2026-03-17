// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./erc20.sol";

contract AirportContract {
    string private _name;
    ERC20Simple private _token;
    uint256 private _totalSupply;
    address payable public owner;

    struct Passenger {
        address id;
        string name;
        bool premium;
    }

    mapping(address => Passenger) private listPassengers;

    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_,
        uint256 initialSupply_
    ) {
        owner = payable (msg.sender);
        _token = new ERC20Simple(name_, symbol_, decimals_, initialSupply_);
    }

    function getName() external view returns (string memory) {
        return _name;
    }

    function getTotalSupply() external view returns (uint256) {
        return _totalSupply;
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
            name: name_
        });

        listPassengers[id_] = passenger;
    }

    function ownerMint(address id, uint256 miles) external onlyOwner {
        _token.mint(id, miles);
    }

    function burn(uint256 amount) external {
        _token.burn(msg.sender, amount);
    }

    function ownerBurn(address from, uint256 amount) external onlyOwner {
        _token.burn(from, amount);
    }
}