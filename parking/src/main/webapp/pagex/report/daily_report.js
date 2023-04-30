var modelConfig = {
    title: '月报表',pkey:'id',type:'snow',table:'t_daily_report_order',
    namespace: "daily_report",dataGridUrl:'${path.basePath}/ms/tollCollector/dailyReport',
    exjs:'${path.staticPath}/js/My97DatePicker/WdatePicker.js,${path.staticPath}/js/dayjs.min.js,${path.staticPath}/js/easyui/datagrid-export.js',isMultiTenant:true
};
var listPage = {
    listFieldSett: function () {
        return [
            {name: 'pay_time', title: '日期', width: '8%', align: 'center'},
            {name: 'receivable', title: '应收', width: '9%', align: 'center'},
            {name: 'real_income', title: '实收', width: '9%', align: 'center'},
            {name: 'out_number', title: '出场车次', width: '8%', align: 'center'},
            {name: 'cash_pay', title: '岗亭现金(非手动抬杆)', width: '10%', align: 'center'},
            {name: 'cash_pay_low', title: '岗亭现金(手动抬杆)', width: '10%', align: 'center'},
            {name: 'gate_pay', title: '网络支付', width: '9%', align: 'center'},
            {name: 'balance_pay', title: '储值卡支付', width: '9%', align: 'center'},
            {name: 'integral_pay', title: '积分支付', width: '9%', align: 'center'},
            {name: 'cash_coupon_pay', title: '优免券', width: '9%', align: 'center'},
            {name: 'cash_coupon_number', title: '优免券使用数量', width: '9%', align: 'center'},
            {name: 'discount_amount', title: '优惠金额', width: '9%', align: 'center'},
            {name: 'special_pay', title: '特殊处理损失', width: '9%', align: 'center'},
        ]
    },
    isColumnButton: function () {
        return false;
    },
    filters: function () {
        return [
            {name: 'park_id', onLoadSuccess:'selectDefaultPark', type: 'select', title: '停车场',url: '${path.pay_api_basePath}/ms/parking/getParkParkingList?jsonpCallback=?',valuefield: 'parkId', textfield: 'parkName'},
            {name: 'pay_time',type: 'date', title: '支付时间',formart:"yyyy-MM",maxDate:'%y-%M', },
];
    },
    buttons: function () {
        return [
            {title:'生成月报表',fun:'exportReportExcel',permissionsCode:'daily_report:see',isRow:false,},
            {title:'导出',fun:'exportReportExcelOnWeb',permissionsCode:'daily_report:see',isRow:false,},
        ];
    },
    disableButtons: function () {
        return ["view","add","update","delete","export"];
    },
    otherFunctions: function () {
        return {
            selectDefaultPark:function(_datas){
                $("#parkIdF").combobox('setValue',_datas[0].id);
            },
            onListPageReady:function(){
                $('#payTimeF').val(dayjs().format('YYYY-MM'));
                setTimeout(reload,1000);
            },
            exportReportExcel:function(){
                var parkIdF = $("#parkIdF").combobox('getValue');
                if(parkIdF == ""){
                    Ealert("停车场不能为空");
                    return;
                }
                var payTimeF = $("#payTimeF").val();
                if(payTimeF == ""){
                    Ealert("时间不能为空");
                    return;
                }
                $.ajax({
                    method: 'post',
                    url: '${path.basePath}/ms/tollCollector/exportDailyReportExcel',
                    dataType: 'json',
                    data:{parkId:parkIdF,payTime:payTimeF},
                    success: function (result) {
                        if (result.code == 400) {
                            Ealert(result.message);
                        } else {
                            Ealert("excel文件正在生成，请稍后在报表夹下载！")
                        }
                    }
                })
            },
            exportReportExcelOnWeb:function () {
                // var arr=$("#listGrid").datagrid('getData');
                $("#listGrid").datagrid('toExcel','月报表.xls');
            }
        }
    }
};

var add = {
    formFields: function () {
        return [
            {name: 'park_name', title: '停车场名称' ,type:'input'},
            {name: 'name', title: '收费员姓名' ,type:'input'},
            {name: 'pay_time', title: '支付日期' ,type:'input'},
            {name: 'stroke_number', title: '收费笔数' ,type:'input'},
            {name: 'actual_amount', title: '收费总金额' ,type:'input'},
        ];
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
            }
        }
    }
};











