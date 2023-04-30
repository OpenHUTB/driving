var modelConfig = {
    title: '未出场车辆列表',pkey:'id',type:'snow',table:'t_report_no_getout_car',
    namespace: "report_not_getout",trans:true,isMultiTenant:true
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
            {name: 'park_id',onLoadSuccess:'selectDefaultPark',type: 'select',title: '停车场',url: '${path.pay_api_basePath}/ms/parking/getParkParkingList?jsonpCallback=?',valuefield: 'parkId', textfield: 'parkName'},
            {name: 'plateNumber', type: 'input', title: '车牌号',filterType:'like'},
            {name: 'overtimeParking', title: '入场时间', type: 'book', code: 'overtime_parking'},
        ];
    },
    buttons: function () {
        return [
            {title: '查看入场图片', fun: 'carEnterImg', permissionsCode: 'report_not_getout:see', isRow: true},
            {title: '标记车辆已出场', fun: 'carOut', permissionsCode: 'report_not_getout:see', isRow: true},
            {title:'导出',fun:'exportReportExcel',permissionsCode:'report_not_getout:see',isRow:false,}
        ];
    },
    disableButtons: function () {
        return ["view","add","update","delete","export"];
    },
    otherFunctions: function () {
        return {
            exportReportExcel:function(){
                var _fieldArray = getExcelFields();
                $.ajax({
                    url: "${path.basePath}/ms/tollCollector/setExportField",
                    type: "post",
                    contentType: "application/json;charset=utf-8",
                    dataType: "json",
                    data: json2str(_fieldArray),
                    success: function (result) {
                        window.location.href = "${path.basePath}/ms/noGetOutCar/exportReportExcel?excelName=" + encodeURIComponent('未出场车辆报表');
                    }
                });

            },
            selectDefaultPark:function(_datas){
                if(_datas.length > 0){
                    $("#parkIdF").combobox('setValue',_datas[0].id);
                    $("#overtimeParkingF").combobox('setValue',1);
                }
                $('#listGrid').datagrid({
                    url:'${path.basePath}/ms/noGetOutCar/getNoOutCarList',
                    queryParams:getGridParam()
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
                    url: "${path.basePath}/ms/noGetOutCar/carOut?parkId="+row.parkId+"&plateNumber="+row.plateNumber+"&accessTime="+row.accessTime+"&id="+row.id,
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












