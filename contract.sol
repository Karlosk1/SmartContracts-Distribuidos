// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./erc20.sol";

contract AirportContract {
    string private _name;
    ERC20Simple private _token;
    address payable public owner;

    struct Passenger {
        address id;
        string name;
    }

    mapping(address => Passenger) private listPassengers;

    // Events
    event UpgradeSeat(address indexed passenger);
    event ExtraLuggage(address indexed passenger, uint256 units);
    event UpgradeUser(address indexed passenger);
    event UpgradeLounge(address indexed passenger);

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

    function getToken() external view returns (ERC20Simple) {
        return _token;
    }

    function getBalancePassenger() external view returns (uint256) {
        return _token.balanceOf(msg.sender);
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

    function burn(uint256 amount) public {
        _token.burn(msg.sender, amount);
    }

    function ownerBurn(address from, uint256 amount) external onlyOwner {
        _token.burn(from, amount);
    }
    
    function upgradeSeat() external {
        uint256 priceSeat = 250;
        burn(priceSeat);

        emit UpgradeSeat(msg.sender);
    }

    function extraLuggage(uint256 numberOfLugagges) external {
        uint256 priceLuggage = 250;
        require(numberOfLugagges >= 1, "Invalid amount");
        uint256 luggage = numberOfLugagges * priceLuggage;
        burn(luggage);

        emit ExtraLuggage(msg.sender, numberOfLugagges);
    }

    function upgradeUser() external {
        uint256 priceUpgrade = 500;
        burn(priceUpgrade);

        emit UpgradeUser(msg.sender);
    }

    function upgradeLounge() external {
        uint256 priceLounge = 500;
        burn(priceLounge);

        emit UpgradeLounge(msg.sender);
    }
}