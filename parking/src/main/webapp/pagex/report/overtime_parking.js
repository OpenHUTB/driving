var modelConfig = {
    title: '未出场车辆列表',pkey:'id',type:'snow',table:'t_park_report_holiday',
    exjs:'${path.staticPath}/js/My97DatePicker/WdatePicker.js',
    namespace: "overtime_parking",trans:true,isMultiTenant:true
};
var listPage = {
    listFieldSett: function () {
        return [
            {name: 'parkName', title: '停车场', width: '20%', align: 'center'},
            {name: 'plateNumber', title: '车牌号', width: '20%', align: 'center'},
            {name: 'accessTime', title: '入场时间', width: '20%', align: 'center'},
            {name: 'portName', title: '出入口', width: '20%', align: 'center'},
            {name: 'recordType', title: '停车类型', width: '19%', align: 'center',trans: 'book', key: 'record_type', showField: 'transMap.recordTypeName'},

        ]
    },
    isColumnButton: function () {
        return false;
    },
    filters: function () {
        return [
            {name: 'park_id', onLoadSuccess:'selectDefaultPark', type: 'select',title: '停车场',url: '${path.pay_api_basePath}/ms/parking/getParkParkingList?jsonpCallback=?',valuefield: 'parkId', textfield: 'parkName'},
            {name: 'plateNumber', type: 'input', title: '车牌号',filterType:'like'},
            {name: 'overtime_parking', title: '入场时间', type: 'book', code: 'overtime_parking',onLoadSuccess:'selectDefaultOvert'},
        ];
    },
    buttons: function () {
        return [
            {title: '查看入场图片', fun: 'carEnterImg', permissionsCode: 'overtime_parking:see', isRow: true},
            {title: '标记车辆已出场', fun: 'carOut', permissionsCode: 'overtime_parking:see', isRow: true},
            {title:'导出',fun:'exportReportExcel',permissionsCode:'overtime_parking:see',isRow:false,}
        ];
    },
    disableButtons: function () {
        //return ["view","add","update","delete","export"];
        return ["view","add","update","delete","export"];
    },
    otherFunctions: function () {
        return {
            selectDefaultPark:function(_datas){
                $("#parkIdF").combobox('setValue',_datas[0].id);
                $("#overtimeParkingF").combobox('setValue',1);
                $('#listGrid').datagrid({
                    url:'${path.basePath}/ms/unattendedsAction/findUnattended',
                    queryParams:getGridParam()
                });
            },onListPageReady:function(){
                //setTimeout(reload,2000);
            },
            selectDefaultOvert:function (_datas) {
                $("#overtimeParkingF").combobox('setValue',_datas[0].orderNum);
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
                        window.location.href = "${path.basePath}/ms/unattendedsAction/exportReportExcel?excelName=" + encodeURIComponent('未出场车辆报表');
                    }
                });

            },
            carEnterImg: function (row) {
                openDialog('${path.basePath}/b/page-ms-common/view_common_img?id='
                    + row.img,
                    '查看入场图片');
            },
            carOut: function (row) {
                $.ajax({
                    type : 'post',
                    url: "${path.basePath}/ms/unattendedsAction/carOut?parkId="+row.parkId+"&plateNumber="+row.plateNumber+"&accessTime="+row.accessTime,
                    contentType: "application/json;charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                            Ealert("操作成功！");
                            reload();
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












