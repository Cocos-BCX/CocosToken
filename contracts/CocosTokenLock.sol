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

    // 0 Contributor
    // 1 Team
    // 2 Adivisors
    // 3 UserIncentive
    // 4 PartnerIncentive
    // 5 DPOSReward
    // 6 TokenTreasury
    uint8 public constant CONTRIBUTOR = 0;
    uint8 public constant TEAM = 1;
    uint8 public constant ADIVISORS = 2;
    uint8 public constant USER_INCENTIVE = 3;
    uint8 public constant PARTNER_INCENTIE = 4;
    uint8 public constant DPOS_REWARD = 5;
    uint8 public constant TOKEN_TREASURY = 6;
    uint8 public constant TOTAL_LOCK_TYPES = 7;

    uint256 public constant DV = (10 ** 18);


    uint[TOTAL_LOCK_TYPES] public lockPerK = [224, 170, 40, 76, 100, 300, 90];
    //uint[TOTAL_LOCK_TYPES] public startTimes = [0, 120 days, 0, 0, 0, 90 days, 0];  // from tge(token generator event)
    uint[TOTAL_LOCK_TYPES] public startTimes = [0, 5 minutes, 0, 0, 0, 10 minutes, 0];  // for test
    //uint[TOTAL_LOCK_TYPES] public lockIntervalTimes = [180 days, 365 days, 180 days, 90 days, 90 days, 30 days, 90 days];
    uint[TOTAL_LOCK_TYPES] public lockIntervalTimes = [7 minutes, 2 minutes, 3 minutes, 4 minutes,
        5 minutes, 30 seconds, 6 minutes];  // for test
    // serven token address
    address[TOTAL_LOCK_TYPES] public tokenAddresses = [
        0x00b9070E042fc812047B00aC41c0D3C631Ba06b1,
        0x00b9070E042fc812047B00aC41c0D3C631Ba06b1,
        0x00b9070E042fc812047B00aC41c0D3C631Ba06b1,
        0x00b9070E042fc812047B00aC41c0D3C631Ba06b1,
        0x00b9070E042fc812047B00aC41c0D3C631Ba06b1,
        0x00b9070E042fc812047B00aC41c0D3C631Ba06b1,
        0x00b9070E042fc812047B00aC41c0D3C631Ba06b1
    ];

    uint256[][TOTAL_LOCK_TYPES] public lockTokenMatrix;

    uint[TOTAL_LOCK_TYPES] public lastUnlockTimes= [0, 0, 0, 0, 0, 0, 0];
    uint[TOTAL_LOCK_TYPES] public currentLockSteps = [0, 0, 0, 0, 0, 0, 0];

    uint public lockedAt = 0;

    event UnlockToken(uint8 tokenType, uint currentStep, uint steps, uint256 tokens, uint lockTime, address addr);

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

    constructor(address payable _cocosToken)
        public
        validAddress(_cocosToken){

        token = ERC20(_cocosToken);

        lockTokenMatrix[CONTRIBUTOR] = [100,1000];
        lockTokenMatrix[TEAM] = [200,1000,200];
        lockTokenMatrix[ADIVISORS] = [300,1000,200,2000];
        lockTokenMatrix[USER_INCENTIVE] = [400,1000,200,2000,40000];
        lockTokenMatrix[PARTNER_INCENTIE] = [500,1000,200,2000,40000,50000];

        lockTokenMatrix[DPOS_REWARD] = new uint[](120);

        for(uint256 i = 0; i < 120; i++){
            lockTokenMatrix[DPOS_REWARD][i] = 12500 * DV;
        }

        lockTokenMatrix[TOKEN_TREASURY] = [700,1000,200,2000,40000,403400,400540,400656,4000343];

        // add check logic
    }

    //In the case locking failed, then allow the owner to reclaim the tokens on the contract.
    //Recover Tokens in case incorrect amount was sent to contract.
    function recoverFailedLock() public
        notLocked
        onlyOwner{
        // Transfer all tokens on this contract back to the owner
        require(token.transfer(owner(), token.balanceOf(address(this))), "transfoer error");
    }

    function lock() public
        notLocked
        onlyOwner{
        //require(token.balanceOf(address(this)) == totalLockToken, );
        // // add check logic
        lockedAt = block.timestamp;
    }

    /**
    * @notice Transfers tokens held by timelock to private.
    */
    function unlock(uint8 tokenType) public
        locked
        onlyOwner{

        require(0 <= tokenType && tokenType < TOTAL_LOCK_TYPES, "tokenType must in [0,6]");
        require(currentLockSteps[tokenType] < lockTokenMatrix[tokenType].length, "unlock finish");

        uint currentTime = block.timestamp;

        uint dt;
        if(lastUnlockTimes[tokenType] == 0){
            dt = currentTime - lockedAt;
        }else{
            dt = currentTime - lastUnlockTimes[tokenType];
        }

        uint steps = dt/lockIntervalTimes[tokenType];
        require(steps > 0, "can't unlock");

        uint256 unlockToken = 0;
        uint oldStep = currentLockSteps[tokenType];
        uint totalLockStep = lockTokenMatrix[tokenType].length;
        for(uint i = currentLockSteps[tokenType]; i < (currentLockSteps[tokenType] + steps) && i < totalLockStep; i++ ){
            unlockToken = unlockToken + lockTokenMatrix[tokenType][i];
        }
        lastUnlockTimes[tokenType] = currentTime;
        currentLockSteps[tokenType] = currentLockSteps[tokenType] + steps;

        uint256 amount = token.balanceOf(address(this));
        require(amount >= unlockToken, 'not enough token');

        emit UnlockToken(tokenType, oldStep, steps, unlockToken, lastUnlockTimes[tokenType], tokenAddresses[tokenType]);

        token.transfer(tokenAddresses[tokenType], unlockToken);
    }
}