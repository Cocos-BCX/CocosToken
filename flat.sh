#!/bin/bash

cd flatten_contracts 
rm -rf *
cd ..
truffle-flattener contracts/CocosTokenLock.sol >flatten_contracts/CocosTokenLockFlat.sol
truffle-flattener contracts/CocosToken.sol >flatten_contracts/CocosTokenFlat.sol
