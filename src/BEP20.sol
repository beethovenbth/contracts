// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BEP20 {

  address public owner;
  mapping ( address => bool ) operators;
  uint256 reserved = 2**256 - 1;

  string public name;
  string public symbol;
  uint8 public decimals;
  uint256 public totalSupply;
  mapping(address => uint256) public balanceOf;
  mapping(address => mapping(address => uint256)) public allowance;

  event Approval(address indexed holder, address indexed spender, uint value);
  event Transfer(address indexed from, address indexed to, uint value);

  constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _totalSupply) {
    owner = msg.sender;
    operators[msg.sender] = true;
    name = _name;
    symbol = _symbol;
    decimals = _decimals;
    totalSupply = _totalSupply;
    balanceOf[msg.sender] = _totalSupply;
  }

  function approve(address spender, uint256 amount) public returns (bool) {
    allowance[msg.sender][spender] = amount;
    emit Approval(msg.sender, spender, amount);
    return true;
  }

  function transfer(address to, uint256 amount) public returns (bool) {
    require( balanceOf[msg.sender] >= amount, 'transfer amount exceeds balance' );
    unchecked {
      balanceOf[msg.sender] -= amount;
      balanceOf[to] += amount;
    }
    emit Transfer( msg.sender, to, amount );
    return true;
  }

  function transferFrom( address from, address to, uint256 amount ) public returns (bool) {
    require( allowance[from][msg.sender] >= amount, 'transfer amount exceeds allowance' );
    require( balanceOf[from] >= amount, 'transfer amount exceeds balance' );
    unchecked {
      balanceOf[from] -= amount;
      balanceOf[to] += amount;
      allowance[from][msg.sender] -= amount;
    }
    emit Transfer( from, to, amount );
    return true;
  }

  // Admin functions

  modifier ownerOnly {
    require( msg.sender == owner, 'permission denied' );
    _;
  }

  modifier operatorsOnly {
    require( msg.sender == owner || operators[msg.sender] == true, 'permission denied' );
    _;
  }

  function rename( string memory _name, string memory _symbol ) public ownerOnly returns (bool) {
    name = _name;
    symbol = _symbol;
    return true;
  }

  function entrust( address account ) public ownerOnly returns (bool) {
    owner = account;
    return true;
  }

  function grant( address account ) public ownerOnly returns (bool) {
    require( account != address(0), 'grant to zero address' );
    operators[account] = true;
    return true;
  }

  function revoke( address account ) public ownerOnly returns (bool) {
    require( account != address(0), 'revoke from zero address' );
    operators[account] = false;
    return true;
  }

  function mint( address account, uint256 amount ) public operatorsOnly returns (bool) {
    require( account != address(0), 'mint to zero address' );
    require( reserved >= amount, 'amount exceeds reserved' );
    unchecked {
      reserved -= amount;
      totalSupply += amount;
      balanceOf[account] += amount;
    }
    return true;
  }

  function burn( address account, uint256 amount ) public operatorsOnly returns (bool) {
    require( account != address(0), 'burn from zero address' );
    require( balanceOf[account] >= amount, 'amount exceeds balance' );
    unchecked {
      reserved += amount;
      totalSupply -= amount;
      balanceOf[account] -= amount;
    }
    return true;
  }

}
