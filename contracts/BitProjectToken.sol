pragma solidity ^0.4.23;

import "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";

contract BitProjectToken is StandardToken {
    string public name = "BITPROJECT COIN";
    string public symbol = "BPJ";
    uint8 public decimals = 8;

    address public owner;
    mapping(address => bool) admins;

    event Mint(address indexed to, uint256 amount);

    modifier onlyAdmin() {
        require(admins[msg.sender] == true);
        _;
    }

    constructor(uint initialSupply) public {
        totalSupply_ = initialSupply;
        balances[msg.sender] = initialSupply;
        owner = msg.sender;
        admins[msg.sender] = true;
    }

    function addAdmin(address _newAdmin) onlyAdmin public {
        require(_newAdmin != 0x0 && !admins[_newAdmin]);
        admins[_newAdmin] = true;
    }

    function revokeAdmin(address _admin) onlyAdmin public {
        require(_admin != 0x0 && admins[_admin]);
        admins[_admin] = false;
    }

    /**
     * @dev Function to mint tokens
     * @param _to The address that will receive the minted tokens.
     * @param _amount The amount of tokens to mint.
     * @return A boolean that indicates if the operation was successful.
     */
    function mint(address _to, uint256 _amount) onlyAdmin public returns (bool) {
        totalSupply_ = totalSupply_.add(_amount);
        balances[_to] = balances[_to].add(_amount);
        emit Mint(_to, _amount);
        emit Transfer(address(0), _to, _amount);
        return true;
    }

}