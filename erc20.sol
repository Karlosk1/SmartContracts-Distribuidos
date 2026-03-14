// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Simple ERC-20 with decimals (no custom errors)
contract ERC20Simple {
    // ======= ERC-20 metadata =======
    string private _name;
    string private _symbol;
    uint8  private _decimals;

    // ======= ERC-20 state =======
    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    // ======= ERC-20 events =======
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_,
        uint256 initialSupply_
    ) {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;

        _mint(msg.sender, initialSupply_);
    }

    // ======= metadata functions =======
    function name() external view returns (string memory) {
        return _name;
    }

    function symbol() external view returns (string memory) {
        return _symbol;
    }

    function decimals() external view returns (uint8) {
        return _decimals;
    }

    // ======= ERC-20 functions =======
    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address owner) external view returns (uint256) {
        return _balances[owner];
    }

    function allowance(address owner, address spender) external view returns (uint256) {
        return _allowances[owner][spender];
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        uint256 currentAllowance = _allowances[from][msg.sender];
        require(currentAllowance >= amount, "ERC20: insufficient allowance");

        // decrease allowance
        _allowances[from][msg.sender] = currentAllowance - amount;
        emit Approval(from, msg.sender, _allowances[from][msg.sender]);

        _transfer(from, to, amount);
        return true;
    }

    // ======= internal helpers =======
    function _transfer(address from, address to, uint256 amount) internal {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");

        _balances[from] = fromBalance - amount;
        _balances[to] += amount;

        emit Transfer(from, to, amount);
    }

    function _mint(address to, uint256 amount) internal {
        require(to != address(0), "ERC20: mint to the zero address");

        _totalSupply += amount;
        _balances[to] += amount;

        // Mint is represented as a Transfer from address(0)
        emit Transfer(address(0), to, amount);
    }

    function _burn(address from, uint256 amount) internal {
        require(from != address(0), "No hay address");
        require(_balances[from] >= amount, "No hay suficientes tokens.");

        _balances[from] -= amount;
        _totalSupply -=amount;

        emit Transfer(from, address(0), amount);
    }

    // Funciones mint y burn
    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) external {
        _burn(from, amount);
    }
}