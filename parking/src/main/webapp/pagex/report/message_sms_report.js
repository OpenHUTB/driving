var modelConfig= {title:'短息通知报表',pkey:'id',type:'snow',
    dataGridUrl:'${path.basePath}/ms/messageSmsReport/messageSmsReportList',
    exjs:'${path.staticPath}/js/My97DatePicker/WdatePicker.js',
    namespace:"message_sms_report",table:'t_message_sms_record',isMultiTenant:true};
var listPage={
    listFieldSett:function(){
        return [

            {name: 'create_time', title: '日期', width: '20%', align: 'center'},
            {name: 'park_name', title: '停车场名称', width: '20%', align: 'center'},
            {name:'message_type',title:'短信类型',width:'20%',align:'center',trans:'book',key:'message_type',showField:'transMap.messageTypeName'},
            {name: 'sms_count', title: '短信数量', width: '20%', align: 'center'},
            {name: 'group_code', title: '集团编号', width: '20%', align: 'center'},
        ]},
    isColumnButton:function(){
        return  false;
    },
    filters:function(){
        return [
            {name:'park_id',type:'select',url:'${path.pay_api_basePath}/ms/parking/getParkParkingList?jsonpCallback=?',
                valuefield:'parkId',textfield:'parkName',title:'停车场',showAll: true},
            {name: 'create_time', type: 'dateBT', title: '日期', formart:"yyyy-MM", isBT:true},
        ];
    },
    buttons: function () {
        return [
            {title:'导出',fun:'downLoadReport',permissionsCode:'message_sms:see',isRow:false,},
        ];
    },
    disableButtons: function () {
        return ["view","add","update","delete","export"];
    },
    otherFunctions: function(){
        return {
            downLoadReport: function () {
                var _fieldArray = getExcelFields();
                $.ajax({
                    url: "${path.basePath}/ms/messageSmsReport/setExportField",
                    type: "post",
                    contentType: "application/json;charset=utf-8",
                    dataType: "json",
                    data: json2str(_fieldArray),
                    success: function (result) {
                        window.location.href = "${path.basePath}/ms/messageSmsReport/messageSmsReportExcel?excelName=" + encodeURIComponent('短信通知报表');
                    }
                });
            },
        }
    }
};
var add={
    formFields:function(){
        return [
            {name:'park_id',type:'select',url:'${path.basePath}/ms/x/parking/findListData',
                valuefield:'id',textfield:'parkName',title:'停车场',required:true},
        ];
    },
    otherFunctions:function(){
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
}
