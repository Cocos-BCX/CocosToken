
// File: openzeppelin-solidity/contracts/math/SafeMath.sol

pragma solidity ^0.5.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}

// File: openzeppelin-solidity/contracts/ownership/Ownable.sol

//pragma solidity ^0.5.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be aplied to your functions to restrict their use to
 * the owner.
 */
contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * > Note: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol

//pragma solidity ^0.5.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see `ERC20Detailed`.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a `Transfer` event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through `transferFrom`. This is
     * zero by default.
     *
     * This value changes when `approve` or `transferFrom` are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * > Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an `Approval` event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a `Transfer` event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to `approve`. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol

//pragma solidity ^0.5.0;



/**
 * @dev Implementation of the `IERC20` interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using `_mint`.
 * For a generic mechanism see `ERC20Mintable`.
 *
 * *For a detailed writeup see our guide [How to implement supply
 * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of ERC20 applications.
 *
 * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See `IERC20.approve`.
 */
contract ERC20 is IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    /**
     * @dev See `IERC20.totalSupply`.
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See `IERC20.balanceOf`.
     */
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See `IERC20.transfer`.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    /**
     * @dev See `IERC20.allowance`.
     */
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See `IERC20.approve`.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 value) public returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    /**
     * @dev See `IERC20.transferFrom`.
     *
     * Emits an `Approval` event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of `ERC20`;
     *
     * Requirements:
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `value`.
     * - the caller must have allowance for `sender`'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to `approve` that can be used as a mitigation for
     * problems described in `IERC20.approve`.
     *
     * Emits an `Approval` event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to `approve` that can be used as a mitigation for
     * problems described in `IERC20.approve`.
     *
     * Emits an `Approval` event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to `transfer`, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a `Transfer` event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount);
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a `Transfer` event with `from` set to the zero address.
     *
     * Requirements
     *
     * - `to` cannot be the zero address.
     */
    // function _mint(address account, uint256 amount) internal {
    //     require(account != address(0), "ERC20: mint to the zero address");

    //     _totalSupply = _totalSupply.add(amount);
    //     _balances[account] = _balances[account].add(amount);
    //     emit Transfer(address(0), account, amount);
    // }

     /**
     * @dev Destoys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a `Transfer` event with `to` set to the zero address.
     *
     * Requirements
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    // function _burn(address account, uint256 value) internal {
    //     require(account != address(0), "ERC20: burn from the zero address");

    //     _totalSupply = _totalSupply.sub(value);
    //     _balances[account] = _balances[account].sub(value);
    //     emit Transfer(account, address(0), value);
    // }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
     *
     * This is internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an `Approval` event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 value) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    /**
     * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
     * from the caller's allowance.
     *
     * See `_burn` and `_approve`.
     */
    // function _burnFrom(address account, uint256 amount) internal {
    //     _burn(account, amount);
    //     _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
    // }
}

// File: contracts/CocosTokenLock.sol

//pragma solidity ^0.5.0;




/**
 * @title CocosTokenLock
 * @dev CocosToken for lock some Cocos token
 * @author reedhong
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


    uint[TOTAL_LOCK_TYPES] public startTimes = [0, 120 days, 30 days, 0, 0, 90 days, 0];  // from tge(token generator event)
    //uint[TOTAL_LOCK_TYPES] public startTimes = [0,  10 seconds, 1 minutes, 0 minutes, 0, 10 seconds, 0];  // for test
    uint[TOTAL_LOCK_TYPES] public lockIntervalTimes = [180 days, 365 days, 90 days, 90 days, 90 days, 30 days, 90 days];
    //uint[TOTAL_LOCK_TYPES] public lockIntervalTimes = [10 seconds, 10 seconds,  3 minutes, 5 seconds,
    //    3 minutes, 2 seconds, 5 seconds];  // for test

    uint public constant ADIVISORS_SECOND_AHEAD_TIME = 30 days;
    //uint public constant ADIVISORS_SECOND_AHEAD_TIME = 2 minutes;  // for test
    uint public constant PARTNER_INCENTIE_SECOND_DELAY_TIME = 30 days;
    //uint public constant PARTNER_INCENTIE_SECOND_DELAY_TIME = 2 minutes; // for test

    // seven token address
    address[TOTAL_LOCK_TYPES] public tokenAddresses = [
        0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C,
        0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB,
        0x583031D1113aD414F02576BD6afaBfb302140225,
        0xdD870fA1b7C4700F2BD7f44238821C26f7392148,
        0x67031f5C338a1e27A1E5B8Ff9bbbA8ab5C59DDC0,
        0x44fAA078bd37caD14238a1A4b267E33E9AACf11d,
        0x6CAb2F342BdD4E5657811f19d639F42A7343bDE8
    ];

    uint256[][TOTAL_LOCK_TYPES] public lockTokenMatrix;

    uint[TOTAL_LOCK_TYPES] public lastUnlockTimes= [0, 0, 0, 0, 0, 0, 0];
    uint[TOTAL_LOCK_TYPES] public currentLockSteps = [0, 0, 0, 0, 0, 0, 0];

    uint public lockedAt = 0;

    event UnlockToken(uint8 tokenType, uint currentStep, uint steps, uint256 tokens, uint lockTime, address addr);
    event CheckTokenDistribution(uint tokenType, uint256 distribution);

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
    }

    function setAddress(uint8 tokenType, address addr) public
        onlyOwner
        validAddress(addr)
        validTokenType(tokenType) {
            tokenAddresses[tokenType] = addr;
        }


    //In the case locking failed, then allow the owner to reclaim the tokens on the contract.
    //Recover Tokens in case incorrect amount was sent to contract.
    function recoverFailedLock() public
        notLocked
        onlyOwner{
        // Transfer all tokens on this contract back to the owner
        require(token.transfer(owner(), token.balanceOf(address(this))), "transfer error");
    }

    function lock() public
        notLocked
        onlyOwner{
        uint256 totalSupply = token.totalSupply();
        require(token.balanceOf(address(this)) == totalSupply, "can't enough token");

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

        uint steps;
        bool isFirst = false;
        if(lastUnlockTimes[tokenType] == 0){  // first time
            uint interval = currentTime - lockedAt;
            if( interval > startTimes[tokenType]){
                steps = 1;
                isFirst = true;
            }
        }else{
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
        lastUnlockTimes[tokenType] = currentTime;
 
        // first time is different
        if(isFirst){
            if( tokenType == ADIVISORS){
                // speed one month
                lastUnlockTimes[tokenType] = lastUnlockTimes[tokenType] - ADIVISORS_SECOND_AHEAD_TIME;
            }else if(tokenType == PARTNER_INCENTIE ) {
                // slow one month
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
