var Web3 = require("web3");
var AirDropABI = require('./AirDropContract');
var Address = require("./airdrop_address");
console.log(Address);
var Value = require("./airdrop_value");
console.log(Value);
var config = require('./config')

if (typeof web3 !== 'undefined') {
    web3 = new Web3(web3.currentProvider);
} else {
    //infura provider
    web3 = new Web3(new Web3.providers.HttpProvider(config.http_provider));
   //web3.setProvider('wss://mainnet.infura.io/_ws');
}

console.log(web3.version)

let myContract = new web3.eth.Contract(AirDropABI, config.airdrop_contract_address);
let data = myContract.methods.transfer(config.erc20_contract_address, Address, Value).encodeABI();

console.log(data);


var rawTransaction = {
    "from": config.from_account,
    "gasPrice": web3.utils.toHex(config.gas_price),
    "gasLimit": web3.utils.toHex(config.gas_limit),
    "to": config.airdrop_contract_address,
    "value": "0x0",
    //"nonce": web3.utils.toHex(nonce),
    "data": data,
};

web3.eth.getBalance(config.from_account)
.then(console.log);

web3.eth.accounts.signTransaction(rawTransaction , config.from_account_pri_key).then(tx => {
    console.log('Result: ', tx);
    var raw = tx.rawTransaction;
    web3.eth.sendSignedTransaction(raw).on('receipt', res => {
        console.log('操作成功');
    }).on('error', err => {
        console.log(err);
        console.log('操作异常');
    });
});


// web3.eth.accounts.decrypt({
//     version: 3,
//     id: '04e9bcbb-96fa-497b-94d1-14df4cd20af6',
//     address: '2c7536e3605d9c16a7a3d7b1898e529396a65c23',
//     crypto: {
//         ciphertext: 'a1c25da3ecde4e6a24f3697251dd15d6208520efc84ad97397e906e6df24d251',
//         cipherparams: { iv: '2885df2b63f7ef247d753c82fa20038a' },
//         cipher: 'aes-128-ctr',
//         kdf: 'scrypt',
//         kdfparams: {
//             dklen: 32,
//             salt: '4531b3c174cc3ff32a6a7a85d6761b410db674807b2d216d022318ceee50be10',
//             n: 262144,
//             r: 8,
//             p: 1
//         },
//         mac: 'b8b010fff37f9ae5559a352a185e86f9b9c1d7f7a9f1bd4e82a5dd35468fc7f6'
//     }
// }, 'Beijing2019'); 