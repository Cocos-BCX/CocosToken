#!/bin/bash

cd flatten_contracts 
rm -rf *
cd ..
./node_modules/.bin/truffle-flattener contracts/CocosTokenLock.sol >flatten_contracts/CocosTokenLockFlat.sol
./node_modules/.bin/truffle-flattener contracts/CocosToken.sol >flatten_contracts/CocosTokenFlat.sol
