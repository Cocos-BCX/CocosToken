var fs = require('fs')

var args = process.argv.splice(1)
var accountFile = args[1];
var valueFile = args[2];

var wr_account_file = args[3];;
var wr_value_file = args[4];


// 读取文件
// 第一个参数就是要读取的文件路径
// 第二个参数是一个回调函数
//          
//        成功
//          data 数据
//          error null
//        失败
//          data undefined没有数据
//          error 错误对象
fs.readFile(accountFile, function (error, data) {
    if (error) {
        // 在这里就可以通过判断 error 来确认是否有错误发生
        console.log('读取账号文件失败了');
    } else {
        // console.log("读账号文件成功了");
        // <Buffer 68 65 6c 6c 6f 20 6e 6f 64 65 6a 73 0d 0a>
        // 文件中存储的其实都是二进制数据 0 1
        // 这里为什么看到的不是 0 和 1 呢？原因是二进制转为 16 进制了
        // 但是无论是二进制01还是16进制，人类都不认识
        // 所以我们可以通过 toString 方法把其转为我们能认识的字符
        var tetData = data.toString();
        // 截取字符串
        var arr = tetData.split("\n");
        console.log("读账号成功了 len" + arr.length);
        var account_reslut = "[";
        arr.forEach(element => {
            if (element.length != 0) {
                account_reslut += "\"" + element + "\"" + ",";
            }
        });
        account_reslut += "]";
        account_reslut = account_reslut.replace(/,]/g, "]")
        // console.log(account_reslut);
        // 第一个参数：文件路径
        // 第二个参数：文件内容
        // 第三个参数：回调函数
        //    成功：
        //      文件写入成功
        //      error 是 null
        //    失败：
        //      文件写入失败
        //      error 就是错误对象
        fs.writeFile(wr_account_file, account_reslut, function (error) {
            if (error) {
                console.log('写入账号失败');
            } else {
                console.log('写入账号成功了');
                value_file_op();
            }
        })
    }
})

// value 操作
function value_file_op() {
    fs.readFile(valueFile, function (error, data) {
        if (error) {
            console.log('读取value文件失败了')
        } else {
            var tetData = data.toString();
            // 截取字符串
            var arr = tetData.split("\n");
            console.log("读value成功了 len " + arr.length);
            var value_reslut = "[";
            arr.forEach(element => {
                if (element.length != 0) {
                    var floatValue = parseFloat(element);
                    var num = new Number(floatValue * Math.pow(10, 18));
                    num = num.toLocaleString();
                    value_reslut += "\"" + num + "\"" + ",";
                }
            });
            value_reslut += "]";
            // 去除最后一个逗号，去除千分位
            value_reslut = value_reslut.replace(/,]/g, "]").replace(/,/g, "").replace(/\"\"/g, "\",\"");
            // console.log(value_reslut);
            fs.writeFile(wr_value_file, value_reslut, function (error) {
                if (error) {
                    console.log('写入value失败')
                } else {
                    console.log('写入value成功了 ')
                }
            })
        }
    })
}
