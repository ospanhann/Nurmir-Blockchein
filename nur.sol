pragma solidity ^0.8.0;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Mint(address indexed to, uint256 amount);
}

contract Nur is IERC20 {
    string public name;
    string public symbol;
    uint8 public decimals = 8;
    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;

    address public contractOwner;

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
        contractOwner = msg.sender;
    }

    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function mint(address _to, uint256 _amount) public {
        require(msg.sender == contractOwner, "Only the contract owner can mint tokens");
        require(_to != address(0), "Mint to the zero address");
        
        _totalSupply += _amount;
        _balances[_to] += _amount;
        emit Transfer(address(0), _to, _amount);
        emit Mint(_to, _amount);
    }

    function _transfer(address sender, address recipient, uint256 amount) private {
        require(sender != address(0), "Transfer from the zero address");
        require(recipient != address(0), "Transfer to the zero address");
        require(amount <= _balances[sender], "Transfer amount exceeds balance");
        
        _balances[sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
    }
}
