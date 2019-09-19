var fs = require('fs')
var address_file = "address.txt";

function check_file_address() {
    fs.readFile(address_file, function (error, data) {
        if (error) {
            console.log('读取账号文件失败了');
        } else {
            console.log("读账号文件成功了");
            var tetData = data.toString();
            // 截取字符串
            var arr = tetData.split("\n");
            console.log("读账号成功了 len" + arr.length);
            
            for (const key in arr) {
                if (arr.hasOwnProperty(key)) {
                    const element = arr[key];
                    if (!eth_address(element)){
                        console.log('-----------', (parseInt(key)+1),element);
                    }
                    
                }
            }
        }
    })
}

function eth_address(str) {
    var myReg = /^(0x)[0-9A-Fa-f]{40}$/;
    if (myReg.test(str)) {
        // console.log('tag', 'success');
        return true;
    }else{
        // console.log('tag', 'error');
        return false;
    }
}

// eth_address("0xbd3E3D4d28E648068316a89D19c1d08C9db78B33");
check_file_address();