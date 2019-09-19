const xlsx = require('node-xlsx')
const fs = require('fs')


// 读取表格第一行的标题
function readExcelTitle(fileName) {
    var xlsData = xlsx.parse(fileName);
    // 取出第一个 sheet 数据
    let sheet = xlsData[0].data;
    // 返回数据
    return sheet[0];
}

// 读取表格的数据
function readExcel(fileName) {
    var xlsData = xlsx.parse(fileName);
    // 取出第一个 sheet 数据
    let sheet = xlsData[0].data
    sheet.shift() //去除第一行标题
    // 返回数据
    return sheet;
}

// 处理需要读取的数据
function handleExcelData(read_data) {
    read_data.forEach(element => {
        // 数组第五个是 eth 地址
        if (!eth_address(element[5])) {
            element[7] = 'false';
        } 
        // 数组第 4 个是否大于 1W 地址
        if (element[4] >= 10000) {
            element[8] = element[4];
        }
    });
    return read_data;
}

// 验证 eth 地址
function eth_address(str) {
    var myReg = /^(0x)[0-9A-Fa-f]{40}$/;
    if (myReg.test(str)) {
        // console.log('tag', 'success');
        return true;
    } else {
        // console.log('tag', 'error');
        return false;
    }
}

// 写入表格
function writeExcel(sheet) {
    let buffer = xlsx.build([{
        name: 'cocosBounty',
        data: sheet
    }])

    fs.writeFile('text.xlsx', buffer, function (err) {
        if (err) throw err;
        console.log('Write to excel has successed');
    })
}

function HandNewExcel() {

    var args = process.argv.splice(1)
    var file = args[1];
    // 读取表格数据
    var read_data = readExcel(file);
    // 需要写入的数据
    var write_data = [];
    // 标题
    var excel_title = readExcelTitle(file);
    excel_title[7] = "地址有效性";
    excel_title[8] = "提现>一万";

    write_data.push(excel_title);
    // 处理之后的数据
    var hand_data = handleExcelData(read_data);
    hand_data.forEach(element => {
        write_data.push(element);    
    });
    
    writeExcel(write_data);    
}

HandNewExcel()