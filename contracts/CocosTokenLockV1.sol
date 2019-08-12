pragma solidity ^0.5.0;

import 'openzeppelin-solidity/contracts/math/SafeMath.sol';
import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';
import 'openzeppelin-solidity/contracts/token/ERC20/ERC20.sol';

/**
 * @title CocosTokenLock
 * @dev CocosToken for lock some Cocos token
 */
contract CocosTokenLock is Ownable {
    using SafeMath for uint;

    ERC20 public token;

    // locak plan 
    uint256 public totalPrivateToken = 20000000000 * (10 ** 18);

    // total: 20 billion
    // 10%, 7.5%, 7.5%, 7.5%, 7.5%, 7.5%, 7.5%
    uint[] public lockPerK = [100,75,75,75,75,75,75];
    uint256  public totalLockToken = 0;
    uint public  totalLockStep = 0;
    uint public lockIntervalTime = 30 days;


    address public privateLockAddress;

    uint public lockedAt = 0; 
    uint public lastUnlockTime = 0;
    uint public currentLockStep = 0;

    event UnlockToken(uint currentStep, uint steps, uint256 tokens, uint lockTime);

    //Has not been locked yet
    modifier notLocked {
        require(lockedAt == 0, "not locked");
        _;
    }

    modifier locked {
        require(lockedAt > 0, "has locked");
        _;
    }

    modifier validAddress( address addr ) {
        require(addr != address(0x0), "address is 0x00");
        require(addr != address(this), "address is myself");
        _;
    }

    constructor(address payable _cocosToken, address _privateLockAddress)
        public
        validAddress(_cocosToken)
        validAddress(_privateLockAddress){

        token = ERC20(_cocosToken);
        privateLockAddress = _privateLockAddress;

        uint totalPerK = 0;
        totalLockStep = lockPerK.length;
        for(uint i = 0; i < totalLockStep; i++){
            totalPerK = totalPerK + lockPerK[i];
        }

        totalLockToken = totalPrivateToken*totalPerK/1000;
    }

    //In the case locking failed, then allow the owner to reclaim the tokens on the contract.
    //Recover Tokens in case incorrect amount was sent to contract.
    function recoverFailedLock() public
        notLocked
        onlyOwner{
        // Transfer all tokens on this contract back to the owner
        require(token.transfer(owner(), token.balanceOf(address(this))));
    }

    function lock() public
        notLocked
        onlyOwner{
        require(token.balanceOf(address(this)) == totalLockToken);
        lockedAt = block.timestamp;
        currentLockStep = 0;
    }

    /**
    * @notice Transfers tokens held by timelock to private.
    */
    function unlock() public
        locked
        onlyOwner{

        require(currentLockStep < totalLockStep, "unlock finish");
        uint currentTime = block.timestamp;

        uint dt;
        if(lastUnlockTime == 0){
            dt = currentTime - lockedAt;
        }else{
            dt = currentTime - lastUnlockTime;
        }

        uint steps = dt/lockIntervalTime;
        require(steps > 0, "can't unlock");

        uint256 unlockToken = 0;
        uint oldStep = currentLockStep;
        for(uint i = currentLockStep; i < (currentLockStep + steps) && i < totalLockStep; i++ ){
            unlockToken = unlockToken + (lockPerK[i] * totalPrivateToken / 1000);
        }
        lastUnlockTime = currentTime;
        currentLockStep = currentLockStep + steps;

        uint256 amount = token.balanceOf(address(this));
        require(amount >= unlockToken, 'not enough token');

        emit UnlockToken(oldStep, steps, unlockToken, lastUnlockTime);

        token.transfer(privateLockAddress, unlockToken);
    }
}