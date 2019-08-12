# ERC20 for Cocos-BCX 

## 执行步骤：
1. 创建合约 CocosToken

2. 创建合约 CocosTokenLock
*     设置正确的间隔时间
*     设置正确的钱包账号

3. 设置创建合约CocosToken的账号为白名单

4. 设置合约 CocosTokenLock 的地址为白名单

5. 把创建合约CocosToken的账号身上的token全部转给 CocosTokenLock 合约地址

6. 调用 CocosTokenLock 的 lock接口，锁住所有的token

7. 以此调用 CocosTokenLock 的 unlock 接口传入不同的类型，解锁token

8. 设置 CocosToken 为 unpuased