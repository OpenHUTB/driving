var modelConfig = {
    title: '收费员线下收费',pkey:'id',type:'snow',table:'t_pay_temp_order',
    namespace: "toll_collector_report",dataGridUrl:'${path.basePath}/ms/tollCollector/underLineData',
    exjs:'${path.staticPath}/js/My97DatePicker/WdatePicker.js',isMultiTenant:true
};
var listPage = {
    listFieldSett: function () {
        return [
            {name: 'park_name', title: '停车场名称', width: '20%', align: 'center'},
            {name: 'name', title: '收费员姓名', width: '10%', align: 'center'},
            {name: 'pay_time', title: '支付日期', width: '9.9%', align: 'center'},
            {name: 'stroke_number', title: '线下收费笔数', width: '10%', align: 'center'},
            {name: 'actual_amount', title: '线下收费金额', width: '10%', align: 'center'},
            {name: 'special_pass_number', title: '特殊放行次数', width: '10%', align: 'center'},
            {name: 'special_pay', title: '特殊放行损失', width: '10%', align: 'center'},
            {name: 'cash_pay', title: '手动抬杆金额', width: '10%', align: 'center'},
            {name: 'cash_number', title: '手动抬杆次数', width: '10%', align: 'center'},
        ]
    },
    isColumnButton: function () {
        return false;
    },
    filters: function () {
        return [
            {name: 'park_id', onLoadSuccess:'selectDefaultPark', type: 'select',title: '停车场',url: '${path.park_report_basePath}/ms/parking/getParkParkingList?jsonpCallback=?',valuefield: 'parkId', textfield: 'parkName',onSelect:'reloadCollector'},
            {name: 'collector_id', type: 'select', title: '收费员', url: '${path.park_report_basePath}/ms/ucenter_toll_collector/getUcenterList?jsonpCallback=?&parkId=',valuefield:'collectorId',textfield:'name'},
            {name: 'pay_time', type: 'dateBT', title: '支付时间',isBT:true},
        ];
    },
    buttons: function () {
        return [
            {title:'线下收费明细',fun:'offlineCharges',permissionsCode:'toll_collector_report:see',isRow:true,id:'offlineChargesBTN'},
            {title:'特殊放行明细',fun:'abnormalRelease',permissionsCode:'toll_collector_report:see',isRow:true,id:'abnormalReleaseBTN'},
            {title:'手动抬杆明细',fun:'handLiftRod',permissionsCode:'toll_collector_report:see',isRow:true,id:'handLiftRodBTN'},
            {title:'导出',fun:'exportReportExcel',permissionsCode:'toll_collector_report:see',isRow:false,},
        ];
    },
    disableButtons: function () {
        return ["view","add","update","delete","export"];
    },
    otherFunctions: function () {
        return {
            selectDefaultPark:function(_datas){
                $("#parkIdF").combobox('setValue',_datas[0].id);
                $('#collectorIdF').combobox('clear');
                $('#collectorIdF').combobox('reload', '${path.park_report_basePath}/ms/ucenter_toll_collector/getUcenterList?jsonpCallback=?&parkId=' + _datas[0].parkId);
                $('#listGrid').datagrid({
                    url:'${path.basePath}/ms/tollCollector/underLineData',
                    queryParams:getGridParam()
                });
            },
            reloadCollector:function(park){
                $('#collectorIdF').combobox('clear');
                $('#collectorIdF').combobox('reload', '${path.park_report_basePath}/ms/ucenter_toll_collector/getUcenterList?jsonpCallback=?&parkId=' + park.parkId);
            },
            offlineCharges:function(row){
                var _openFrameMsg = {url:'${path.park_report_basePath}/ms/pagex/pay_temp_order_list.jsp?loadDft=false&type=pay&collectorId='+row.collectorId+'&payTime='+row.payTime+'&parkId='+row.parkId,title: '线下收费详情列表'}
                top.postMessage(_openFrameMsg, '*');
            },
            abnormalRelease:function(row){
                var _openFrameMsg = {url:'${path.park_report_basePath}/ms/pagex/pay_temp_order_list.jsp?loadDft=false&type=free&collectorId='+row.collectorId+'&payTime='+row.payTime+'&parkId='+row.parkId,title: '异常放行详情列表'}
                top.postMessage(_openFrameMsg, '*');
            },
            handLiftRod:function(row){
                var _openFrameMsg = {url:'${path.park_report_basePath}/ms/pagex/pay_hand_lift_rod_list.jsp?collector_id='+row.collectorId+'&update_time='+row.payTime,title: '手动抬杆详情列表'}
                top.postMessage(_openFrameMsg, '*');
            },
            exportReportExcel:function(){
                var _fieldArray = getExcelFields();
                $.ajax({
                    url: "${path.basePath}/ms/tollCollector/setExportField",
                    type: "post",
                    contentType: "application/json;charset=utf-8",
                    dataType: "json",
                    data: json2str(_fieldArray),
                    success: function (result) {
                        window.location.href = "${path.basePath}/ms/tollCollector/exportReportExcel?excelName=" + encodeURIComponent('收费员线下收费报表');
                    }
                });

            },

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











