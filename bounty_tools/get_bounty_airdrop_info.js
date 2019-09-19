const xlsx = require('node-xlsx')
const fs = require('fs')

// txt文件夹名称
var txt_folder_name = "./account_value_txt/";
// json文件夹名称
var json_folder_name = "./account_value_json/";

// 读取表格的数据
function readExcel() {
    var args = process.argv.splice(1) 
    var filename = args[1];
    var xlsData = xlsx.parse(filename);
    // 取出第一个 sheet 数据
    let sheet = xlsData[0].data
    sheet.shift() //去除第一行标题
    // 返回数据
    return sheet;
}
var begin_index = 0;

// Excel 转 TXT
function handleSheetData(excel_Data) {
     // 文件索引
     var file_index = (begin_index/80+1);
     var txt_file_pre = txt_folder_name+file_index;
     var json_file_pre = json_folder_name+file_index;
     // txt 写入
     var w_account_txt_file = txt_file_pre + "account.txt";
     var w_value_txt_file = txt_file_pre+"value.txt";
     // json 写入
     var w_account_json_file = json_file_pre+"account.json";
     var w_value_json_file = json_file_pre+"value.json";

    // 需要写入的数据
    var txt_account_data = "";
    var txt_value_data = "";
    var json_account_data = "[";
    var json_value_data = "[";
    for (var i = begin_index; i<begin_index+80; i++){
        var rowData = excel_Data[i];
         // 数组第五个是 eth 地址
         // 数组第四个是 eth value
         if (rowData != undefined) {
             if (rowData.length > 0 && rowData[5]!= undefined && rowData[4] != undefined){
                var account = rowData[5];
                var value = rowData[4];
                txt_account_data += account + "\n";
                txt_value_data += value + "\n";

                if (account.length != 0) {
                    json_account_data += "\"" + account + "\"" + ",";
                }

                if (value.length != 0) {
                    var floatValue = parseFloat(value);
                    var num = new Number(floatValue * Math.pow(10, 18));
                    num = num.toLocaleString();
                    json_value_data += "\"" + num + "\"" + ",";
                }
            }
         }
    }
    json_account_data += "]";
    json_account_data = json_account_data.replace(/,]/g, "]")

    json_value_data += "]";
    json_value_data = json_value_data.replace(/,]/g, "]").replace(/,/g, "").replace(/\"\"/g, "\",\"");

    // 写入 account txt
    fs.writeFile(w_account_txt_file, txt_account_data, function (error) {
        if (error) {
            // console.log('写入账号 txt 失败');
        } else {
            // console.log('写入账号 txt 成功了');
        }
    })
    
    // 写入 value txt
    fs.writeFile(w_value_txt_file, txt_value_data, function (error) {
        if (error) {
            // console.log('写入金额 txt 失败');
        } else {
            // console.log('写入金额 txt 成功了');
        }
    })
    // 写入 account json
    fs.writeFile(w_account_json_file, json_account_data, function (error) {
        if (error) {
            // console.log('写入账号 json 失败');
        } else {
            // console.log('写入账号 json 成功了');
        }
    })
    // 写入 value json
    fs.writeFile(w_value_json_file, json_value_data, function (error) {
        if (error) {
            // console.log('写入金额 json 失败');
        } else {
            // console.log('写入金额 json 成功了');
        }
    })
    begin_index += 80;
    if (begin_index > excel_Data.length){
        // console.log('Excel 全部转换为 txt 成功');
        return;
    }
    handleSheetData(excel_Data);
}


// 处理 excel 得到 txt
var excel_data = readExcel();
handleSheetData(excel_data);
