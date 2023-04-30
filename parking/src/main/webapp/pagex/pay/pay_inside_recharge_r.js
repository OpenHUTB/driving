var modelConfig = {
    title: '月租充值记录', pkey: 'id', type: 'snow', orderBy: 'update_time Desc', namespace: "pay_inside_recharge_r", table: 't_pay_inside_recharge',
    dp: JSON.stringify({park_id: 'parkIds'}),db:"park", exjs: '${path.staticPath}/js/My97DatePicker/WdatePicker.js', isMultiTenant: true
};
var listPage = {
    listFieldSett: function () {
        return [
            {name: 'parkName', title: '停车场名称', width: '15%', align: 'center'},
            {name: 'ownerName', title: '客户姓名', width: '15%', align: 'center'},
            {name: 'ownerMobile', title: '电话', width: '15%', align: 'center'},
            {name: 'roomNum', title: '房间号', width: '15%', align: 'center'},
            {name: 'plateNums', title: '车牌号', width: '15%', align: 'center'},
            {name: 'amount', title: '充值金额', width: '10%', align: 'center'},
            {name: 'giveAmount', title: '赠送金额', width: '10%', align: 'center'},
            {name: 'isContract', title: '车位信息', width: '15%', align: 'center', handle: 'lotInfo', showField: 'lotInfo'},
            {name: 'createUserName', title: '操作人', width: '10%', align: 'center'},
            {name: 'createTime', title: '操作时间', width: '15%', align: 'center'},
            {name: 'fromType', title: '充值方式', width: '15%', align: 'center'},
        ]
    },
    isColumnButton: function () {
        return true;
    },
    filters: function () {
        return [
            {
                name: 'park_id', type: 'select', url: '${path.basePath}/ms/x/parking/findListData',
                valuefield: 'id', textfield: 'parkName', title: '停车场', showAll: true
            },
            {name: 'ownerName', type: 'input', title: '客户姓名', filterType: 'like'},
            {name: 'ownerMobile', type: 'input', title: '电话', filterType: 'like'},
            {name: 'plateNums', type: 'input', title: '车牌号', filterType: 'like'},
            {name: 'create_time', type: 'dateBT', title: '充值时间', isBT: true},
            {name:'is_contract',type:'book',code:'yesOrNo',title:'是否仅月租'}
        ];
    },
    buttons: function () {
        return [
            {title: '导出', fun: 'exportExcel', permissionsCode: 'pay_inside_recharge_r:see', isRow: false,},
        ];
    },
    disableButtons: function () {
        return ["view", "add", "update", "delete", "export"];
    },
    otherFunctions: function () {
        return {
            onListPageReady: function () {
                $('#isContractF').next(".combo").hide();
                $('#isContractF').combobox('setValue',1);
                var currentdate = getNowTime("yyyy-MM-dd");
                $('#createTime_start_F').val(currentdate + " 00:00:00");
                $('#createTime_end_F').val(currentdate + " 23:59:59");
                setTimeout(function () {
                    $('#listGrid').datagrid({
                        url:'${path.basePath}/ms/pay_inside_recharge_r/findPageByRecharge',
                        queryParams:getGridParam()
                    });
                }, 200);

            },
            exportExcel: function () {
                reload();
                var parkIdF = $("#parkIdF").combobox('getValue');
                if(parkIdF == ""){
                    Ealert("停车场不能为空");
                    return;
                }
                setTimeout(function(){
                    $.ajax({
                        method:'post',
                        url:'${path.basePath}/ms/pay_inside_recharge_r/rechargeExportExcel',
                        contentType: "application/json;charset=utf-8",
                        dataType: "json",
                        success: function(result){
                            if(result.code == 400){
                                EalertE(result.message);
                            }else{
                                Ealert("excel文件正在生成，请稍后在报表夹下载！")
                            }
                        }
                    })
                },1000)
            }
        }
    }
};
var add = {
    formFields: function () {
        return [];
    },
    otherFunctions: function () {
        return {
            ready: function () {
            },
            loadSuccess: function (info) {
            },
            onSave: function () {
            },
            saveSucess: function () {
            },
            saveError: function () {

            },
        }
    }
}
