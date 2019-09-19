const xlsx = require('node-xlsx')
const fs = require('fs')
var args = process.argv.splice(1)
var filename = args[1];
var fromindex = args[2];
var account_txt = args[3];
var value_txt = args[4];
 

// 读取表格的数据
function readExcel() {
    var xlsData = xlsx.parse(filename);
    // 取出第一个 sheet 数据
    let sheet = xlsData[0].data
    sheet.shift() //去除第一行标题
    // 返回数据
    return sheet;
}

function handleSheetDataToETHAddr(sheetData) {
    // 需要写入的数据
    var eth_addr_data = "";
    var begin_index = parseInt(fromindex);
    for (var i = begin_index; i<begin_index+80; i++){
        var rowData = sheetData[i];
         // 数组第五个是 eth 地址
         if (rowData != undefined) {
            eth_addr_data += rowData[5] + "\n";
         }
    }
    fs.writeFile(account_txt, eth_addr_data, function (error) {
        if (error) {
            console.log('写入账号失败');
        } else {
            console.log('写入账号成功了');
        }
    })
}

function handleSheetDataToValue(sheetData) {
    // 需要写入的数据
    var eth_value_data = "";
    var begin_index = parseInt(fromindex);
    for (var i = begin_index; i<begin_index+80; i++){
        var element = sheetData[i];
         // 数组第五个是 eth 地址
         if (element != undefined) {
            eth_value_data += element[4] + "\n";
         }
    }
    fs.writeFile(value_txt, eth_value_data, function (error) {
        if (error) {
            console.log('写入金额失败');
        } else {
            console.log('写入金额成功了');
        }
    })
}
var excel_data = readExcel();
handleSheetDataToETHAddr(excel_data);
handleSheetDataToValue(excel_data);
