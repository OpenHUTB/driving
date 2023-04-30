var modelConfig= {title:'生成报表',pkey:'id',type:'snow',orderBy:'update_time Desc',
    namespace:"report_task",table:'t_report_task',trans:true,db:"park",dp:JSON.stringify({park_id:'parkIds'}),isMultiTenant:true};
var listPage={
    listFieldSett:function(){
        return [
            {name:'park_id',title:'停车场名称',width:'20%',trans:'simple',target:'com.xhb.park.bean.ParkParking',field:'parkName',showField:'transMap.parkName',align:'center'},
            {name:'report_name',title:'报表名称',width:'15%',align:'center'},
            {name:'report_status',title:'表单生成状态',width:'15%',align:'center',trans:'book',key:'report_status',showField:'transMap.report_statusName'},
            {name:'time_describe',title:'时间',width:'20%',align:'center'},
            {name:'report_type',title:'表单类型',width:'15%',align:'center',trans:'book',key:'report_type',showField:'transMap.report_typeName'},
            {name:'group_code',title:'集团编号',width:'14%',align:'center'},
            {name:'excel_file_id',title:'文件id',width:'20%',align:'center',hidden:true},
        ]},
    isColumnButton:function(){
        return  false;
    },
    filters:function(){
        return [
            {name:'park_id',type:'select',url:'${path.pay_api_basePath}/ms/parking/getParkParkingList?jsonpCallback=?',
                valuefield:'parkId',textfield:'parkName',title:'停车场',showAll: true},
            {name: 'report_type', title: '表单类型', type: 'book', code: 'report_type', showAll: true},
            {name:'time_describe',type:'input',title:'时间',filterType:'like'},
        ];
    },
    buttons: function () {
        return [
            {title:'下载',fun:'downLoadReport',permissionsCode:'report_task:see',isRow:true,},
            /*{title:'OA报表',fun:'oaParkMonthWord',permissionsCode:'pay_temp_order:see',isRow:false,}*/

        ];
    },
    disableButtons: function () {
        return ["view","add","update","export"];
    },
    otherFunctions: function(){
        return {
            downLoadReport: function (row) {
                if(row.reportStatus == "0"){
                    Ealert("excel文件正在生成，稍后请重新打开报表文件夹下载！")
                    return false;
                }
                var fileName = row.transMap.parkName+row.timeDescribe+row.reportName + ".xls";
                window.location.href = '${path.fhs_file_basePath}/downLoad/file?fileId=' + row.excelFileId+'&fileName='+encodeURIComponent(fileName);
    },
            oaParkMonthWord : function () {
                openDialog('${path.basePath}/b/page-ms-report/oa_park_report',
                    'OA报表');
            }
        }
    }
};
var add={
    formFields:function(){
        return [
            {name:'park_id',type:'select',url:'${path.pay_api_basePath}/ms/parking/getParkParkingList?jsonpCallback=?',
                valuefield:'parkId',textfield:'parkName',title:'停车场',required:true},
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
