var Web3 = require("web3");
var AirDropABI = require('./AirDropContract');
var config = require('./config')

var args = process.argv.splice(1)
var Address = require("./account_value_json/" + args[1] + "account");
console.log(Address);
var Value = require("./account_value_json/" + args[1] + "value");
console.log(Value);

console.log("输入 go 开始执行");

process.stdin.on('data', (input) => {
    input = input.toString().trim();
    console.log("输入是:" + input)
    if (["go"].indexOf(input) > -1) {
        transfer()
    }else{
        console.log("输入 go 开始执行");
    }
})

function transfer() {
    console.log("开始执行");
    if (typeof web3 !== 'undefined') {
        web3 = new Web3(web3.currentProvider);
    } else {
        web3 = new Web3(new Web3.providers.HttpProvider(config.http_provider));
    }

    let myContract = new web3.eth.Contract(AirDropABI, config.airdrop_contract_address);
    let data = myContract.methods.transfer(config.erc20_contract_address, Address, Value).encodeABI();
    console.log(data);

    var gasPrice = 5 * 1000000000;
    var gasLimit = 3000000;

    var rawTransaction = {
        "from": config.from_account,
        "gasPrice": web3.utils.toHex(gasPrice),
        "gasLimit": web3.utils.toHex(gasLimit),
        "to": config.airdrop_contract_address,
        "value": "0x0",
        "data": data,
    };
    web3.eth.getBalance(config.from_account).then(console.log);
    // 1550806406484366000
    web3.eth.accounts.signTransaction(rawTransaction, config.from_account_pri_key).then(tx => {
        // console.log('Result: ', tx);
        var raw = tx.rawTransaction;
        web3.eth.sendSignedTransaction(raw).on('receipt', res => {
            console.log('操作成功', res);
        }).on('error', err => {
            console.log(err);
            console.log('操作异常');
        });
    });
}