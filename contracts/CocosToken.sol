pragma solidity ^0.5.0;

import 'openzeppelin-solidity/contracts/token/ERC20/ERC20.sol';
import 'openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol';
import 'openzeppelin-solidity/contracts/lifecycle/Pausable.sol';
import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';

/// @title CocosToken Contract
/// For more information about this token please visit https://cocosbcx.io
/// @author reedhong

contract CocosToken is ERC20, ERC20Detailed, Pausable, Ownable  {
    using SafeMath for uint;

    /// Constant token specific fields
    uint8 public constant DECIMALS = 18;
    uint256 public constant INITIAL_SUPPLY = 100000000000 * (10 ** uint256(DECIMALS));


    // black list
    mapping(address => uint) blackAccountMap;
    address[] public blackAccounts;

    // white list
    mapping(address => uint) whiteAccountMap;
    address[] public whiteAccounts;

    event TransferMuti(uint256 len, uint256 amount);

    event AddWhiteAccount(address indexed operator, address indexed whiteAccount);
    event AddBlackAccount(address indexed operator, address indexed blackAccount);

    event DelWhiteAccount(address indexed operator, address indexed whiteAccount);
    event DelBlackAccount(address indexed operator, address indexed blackAccount);

    modifier validAddress( address addr ) {
        require(addr != address(0x0), "address is not 0x0");
        require(addr != address(this), "address is not contract");
        _;
    }


    /**
     * CONSTRUCTOR
     *
     * @dev Initialize the Cocos Token
     */

    constructor () public ERC20Detailed("CocosToken", "COCOS", DECIMALS) {
        pause();
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    function() external payable {
        revert();
    }

   function transfer(address _to, uint256 _value) public returns (bool)  {
        if (paused() == true) {
            // , only white list pass
            require(whiteAccountMap[msg.sender] != 0, "contract is in paused, only in white list can transfer");
        }
        else {
            // check black list
            require(blackAccountMap[msg.sender] == 0,"address in black list, can't transfer");
        }
        return super.transfer(_to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        if (paused() == true) {
            // frozen contract , only white list pass
            require(whiteAccountMap[msg.sender] != 0, "contract is in  paused, can't transfer");
            if (msg.sender != _from) {
                require(whiteAccountMap[_from] != 0, "contract is in  paused, can't transfer");
            }
        }
        else {
            // check black list
            require(blackAccountMap[msg.sender] == 0, "address in black list, can't transfer");
            if (msg.sender != _from) {
                require(blackAccountMap[_from] == 0,"address in black list, can't transfer");
            }
        }

        return super.transferFrom(_from, _to, _value);
    }

    // people will transfer cocos to contract, fix it
    function withdrawFromContract(address _to) public onlyOwner validAddress(_to) returns (bool)  {
        uint256 contractBalance = balanceOf(address(this));
        require(contractBalance > 0, "not enough balance");

        _transfer(address(this), _to, contractBalance);
        return true;
    }


    function addWhiteAccount(address _whiteAccount) public
        onlyOwner
        validAddress(_whiteAccount){
        require(whiteAccountMap[_whiteAccount]==0, "has in white list");

        uint256 index = whiteAccounts.length;
        require(index < 4294967296, "white list is too long");

        whiteAccounts.length += 1;
        whiteAccounts[index] = _whiteAccount;
        
        whiteAccountMap[_whiteAccount] = index + 1;
        emit AddWhiteAccount(msg.sender,_whiteAccount);
    }

    function delWhiteAccount(address _whiteAccount) public
        onlyOwner
        validAddress(_whiteAccount){
        require(whiteAccountMap[_whiteAccount]!=0,"not in white list");

        uint256 index = whiteAccountMap[_whiteAccount];
        if (index == whiteAccounts.length)
        {
            whiteAccounts.length -= 1;
        }else{
            address lastaddress = whiteAccounts[whiteAccounts.length-1];
            whiteAccounts[index-1] = lastaddress;
            whiteAccounts.length -= 1;
            whiteAccountMap[lastaddress] = index;
        }
        delete whiteAccountMap[_whiteAccount];
        emit DelWhiteAccount(msg.sender,_whiteAccount);
    }

    function addBlackAccount(address _blackAccount) public
        onlyOwner
        validAddress(_blackAccount){
        require(blackAccountMap[_blackAccount]==0,  "has in black list");

        uint256 index = blackAccounts.length;
        require(index < 4294967296, "black list is too long");

        blackAccounts.length += 1;
        blackAccounts[index] = _blackAccount;
        blackAccountMap[_blackAccount] = index + 1;

        emit AddBlackAccount(msg.sender, _blackAccount);
    }

    function delBlackAccount(address _blackAccount) public
        onlyOwner
        validAddress(_blackAccount){
        require(blackAccountMap[_blackAccount]!=0,"not in black list");

        uint256 index = blackAccountMap[_blackAccount];
        if (index == blackAccounts.length)
        {
            blackAccounts.length -= 1;
        }else{
            address lastaddress = blackAccounts[blackAccounts.length-1];
            blackAccounts[index-1] = lastaddress;
            blackAccounts.length -= 1;
            blackAccountMap[lastaddress] = index;
        }

        delete blackAccountMap[_blackAccount];
        emit DelBlackAccount(msg.sender, _blackAccount);
    }

}