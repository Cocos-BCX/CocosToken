pragma solidity ^0.5.0;

import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';
import 'openzeppelin-solidity/contracts/token/ERC20/ERC20.sol';

/**
 * @title CocosTokenLock
 * @dev CocosToken for lock some Cocos token
 * @author reedhong
 */
contract CocosTokenLock is Ownable {
    ERC20 public token;

    // 0 Contributor
    // 1 Team
    // 2 Adivisors
    // 3 UserIncentive
    // 4 PartnerIncentive
    // 5 DPOSReward
    // 6 TokenTreasury
    uint8 public constant CONTRIBUTOR = 0;  // 4
    uint8 public constant TEAM = 1; // 3
    uint8 public constant ADIVISORS = 2; // 13
    uint8 public constant USER_INCENTIVE = 3; // 41
    uint8 public constant PARTNER_INCENTIE = 4; // 21
    uint8 public constant DPOS_REWARD = 5; // 120
    uint8 public constant TOKEN_TREASURY = 6; //21
    uint8 public constant TOTAL_LOCK_TYPES = 7;

    uint256 public constant DV = (10 ** 18);


    uint256[TOTAL_LOCK_TYPES] public tokenDistribution = [
        22396452170 * DV,
        17000000000 * DV,
        4000000000 * DV,
        7603547830 * DV,
        10000000000 * DV,
        30000000000 * DV,
        9000000000 * DV
    ];


    uint[TOTAL_LOCK_TYPES] public startTimes = [0, 365 days, 30 days, 0, 0, 90 days, 0];  // from tge(token generator event)
    //uint[TOTAL_LOCK_TYPES] public startTimes = [0,  10 seconds, 1 minutes, 0 minutes, 0, 10 seconds, 0];  // for test
    uint[TOTAL_LOCK_TYPES] public lockIntervalTimes = [180 days, 365 days, 90 days, 90 days, 90 days, 30 days, 90 days];
    //uint[TOTAL_LOCK_TYPES] public lockIntervalTimes = [10 seconds, 10 seconds,  3 seconds, 5 seconds,
    //    3 seconds, 2 seconds, 5 seconds];  // for test

    uint public constant ADIVISORS_SECOND_AHEAD_TIME = 30 days;
    //uint public constant ADIVISORS_SECOND_AHEAD_TIME = 2 minutes;  // for test
    uint public constant PARTNER_INCENTIE_SECOND_DELAY_TIME = 30 days;
    //uint public constant PARTNER_INCENTIE_SECOND_DELAY_TIME = 2 minutes; // for test

    // seven token address
    address[TOTAL_LOCK_TYPES] public tokenAddresses = [
        0xf9948BD195a7Aa64FbBc461B8D1286873C364721,
        0xf18E50748AC2882E7F4b87A147F31453ef69C08B,
        0x5E401eB4E132B17A3217401c9b0e51EA1B608e28,
        0x82d54E42b88522b936E4139A758d5fA3D4Bb35c1,
        0x8da5569f3831CAB8Fc6439AF4bC4fcAa7C729250,
        0x6eD0885ec149d8c8504a4cBcD5067F7fb011cc0c,
        0x6a5d6692d847c83d047bFCaC293FAF02e1488a64
    ];

    uint256[][TOTAL_LOCK_TYPES] public lockTokenMatrix;

    uint[TOTAL_LOCK_TYPES] public lastUnlockTimes= [0, 0, 0, 0, 0, 0, 0];
    uint[TOTAL_LOCK_TYPES] public currentLockSteps = [0, 0, 0, 0, 0, 0, 0];

    uint public lockedAt = 0;

    event UnlockToken(uint8 tokenType, uint currentStep, uint steps, uint256 tokens, uint lockTime, address addr);
    event CheckTokenDistribution(uint tokenType, uint256 distribution);
    event RecoverFailedLock(uint256 token);
    event SetAddress(uint8 tokenType, address addr);

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

    modifier validTokenType(uint8 tokenType ){
        require(0 <= tokenType && tokenType < TOTAL_LOCK_TYPES, "tokenType must in [0,6]");
        _;
    }

    constructor(address payable _cocosToken)
        public
        validAddress(_cocosToken){
        token = ERC20(_cocosToken);

        lockTokenMatrix[CONTRIBUTOR] = [
            12025214795 * DV,
            5353626719 * DV,
            4582828047 * DV,
            434782609 * DV
        ];
        lockTokenMatrix[TEAM] = [
            5692583331 * DV,
            5691833331 * DV,
            5615583338 * DV
        ];
        lockTokenMatrix[ADIVISORS] = [
            350000000 * DV,
            433333332 * DV,
            577833332 * DV,
            83333332 * DV,
            577833332 * DV,
            83333332 * DV,
            577833332 * DV,
            83333332 * DV,
            899833332 * DV,
            83333332 * DV,
            83333332 * DV,
            83333332 * DV,
            83333348 * DV
        ];
    }

    function setAddress(uint8 tokenType, address addr) public
        onlyOwner
        validAddress(addr)
        validTokenType(tokenType) {
            tokenAddresses[tokenType] = addr;
            emit SetAddress(tokenType, addr);
        }


    //In the case locking failed, then allow the owner to reclaim the tokens on the contract.
    //Recover Tokens in case incorrect amount was sent to contract.
    function recoverFailedLock() public
        notLocked
        onlyOwner{
        // Transfer all tokens on this contract back to the owner
        uint256 balance = token.balanceOf(address(this));
        require(token.transfer(owner(), balance), "transfer error");
        emit RecoverFailedLock(balance);
    }

    function lock() public
        notLocked
        onlyOwner{
        uint256 totalSupply = token.totalSupply();
        require(token.balanceOf(address(this)) == totalSupply, "can't enough token");

        lockTokenMatrix[USER_INCENTIVE] = new uint256[](41);
        for(uint256 i = 0; i < 40; i++){
            lockTokenMatrix[USER_INCENTIVE][i] = 190000000 * DV;
        }
        lockTokenMatrix[USER_INCENTIVE][40] = 3547830 * DV; //totalSupply * lockPerK[USER_INCENTIVE] - 190000000 * DV * 40;

        lockTokenMatrix[PARTNER_INCENTIE] = new uint256[](21);
        lockTokenMatrix[PARTNER_INCENTIE][0] = 2000000000 * DV;
        for(uint256 i = 1; i < 21; i++){
            lockTokenMatrix[PARTNER_INCENTIE][i] = 400000000 * DV;
        }

        lockTokenMatrix[DPOS_REWARD] = new uint256[](120);
        for(uint256 i = 0; i < 120; i++){
            lockTokenMatrix[DPOS_REWARD][i] = 250000000 * DV;
        }

        lockTokenMatrix[TOKEN_TREASURY] = new uint256[](21);
        lockTokenMatrix[TOKEN_TREASURY][0] = 1500000000 * DV;
        for(uint256 i = 1; i < 21; i++){
            lockTokenMatrix[TOKEN_TREASURY][i] = 375000000 * DV;
        }

        // check lock percentage
        uint tokenCount = 0;
        for(uint i = 0; i < tokenDistribution.length; i++){
            tokenCount = tokenCount + tokenDistribution[i];
        }
        require(tokenCount == totalSupply, "error lock rate, please check it again");

        // check token set
        for(uint i = 0; i < TOTAL_LOCK_TYPES; i++){
            uint256 tokens = tokenDistribution[i];
            uint256 count = 0;
            for(uint j = 0; j < lockTokenMatrix[i].length; j++ ){
                count = count + lockTokenMatrix[i][j];
            }
            require(tokens == count, "error token set");
            emit CheckTokenDistribution(i, tokens);
        }

        lockedAt = block.timestamp;
    }

    /**
    * @notice unlock token by type
    */
    function unlock(uint8 tokenType) public
        locked
        onlyOwner
        validTokenType(tokenType){
        require(currentLockSteps[tokenType] < lockTokenMatrix[tokenType].length, "unlock finish");

        uint currentTime = block.timestamp;

        uint steps = 0;
        bool isFirst = false;
        if(lastUnlockTimes[tokenType] == 0){  // first time
            uint interval = currentTime - lockedAt;
            if( interval > startTimes[tokenType]){
                steps = 1;
                isFirst = true;
            }
        }else{
            require(lastUnlockTimes[tokenType] <= currentTime, "subtraction overflow");
            uint dt = currentTime - lastUnlockTimes[tokenType];
            steps = dt/lockIntervalTimes[tokenType];
        }

        require(steps > 0, "can't unlock");

        uint256 unlockToken = 0;
        uint oldStep = currentLockSteps[tokenType];
        uint totalLockStep = lockTokenMatrix[tokenType].length;
        for(uint i = currentLockSteps[tokenType]; i < (currentLockSteps[tokenType] + steps) && i < totalLockStep; i++ ){
            unlockToken = unlockToken + lockTokenMatrix[tokenType][i];
        }
        lastUnlockTimes[tokenType] = lastUnlockTimes[tokenType] + steps * lockIntervalTimes[tokenType];
 
        // first time is different
        if(isFirst){
            lastUnlockTimes[tokenType] = lockedAt + startTimes[tokenType];

            if( tokenType == ADIVISORS){
                lastUnlockTimes[tokenType] = lastUnlockTimes[tokenType] - ADIVISORS_SECOND_AHEAD_TIME;
            }else if(tokenType == PARTNER_INCENTIE ) {
                lastUnlockTimes[tokenType] = lastUnlockTimes[tokenType] + PARTNER_INCENTIE_SECOND_DELAY_TIME;
            }
        }

        currentLockSteps[tokenType] = currentLockSteps[tokenType] + steps;

        uint256 amount = token.balanceOf(address(this));
        require(amount >= unlockToken, 'not enough token');

        emit UnlockToken(tokenType, oldStep, steps, unlockToken, lastUnlockTimes[tokenType], tokenAddresses[tokenType]);

        token.transfer(tokenAddresses[tokenType], unlockToken);
    }
}