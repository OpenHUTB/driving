var modelConfig = {title: '车辆进出',pkey: 'id',type: 'snow',orderBy: 'access_time Desc',namespace: "pay_carcome",
    dataGridUrl:'${path.basePath}/ms/pay_carcome_history/queryPager',saveUrl:'${path.basePath}/ms/pay_carcome_history/save',
    updateUrl:'${path.basePath}/ms/pay_carcome_history/modify',
    infoUrl:'${path.basePath}/ms/pay_carcome_history/detail?id=',
    table: 't_pay_carcome',trans: true,db:"park",dp:JSON.stringify({park_id:'parkIds'}),isMultiTenant:true,isNotTotal:true
};
var listPage = {
    listFieldSett: function () {
        return [
            {name: 'park_id',title:'停车场名称',width:'20%',align:'center',trans:'simple',target:'com.xhb.park.bean.ParkParking',field:'parkName',showField:'transMap.parkName'},
            {name: 'port_id', title:'出入口名称', width:'10%',align:'center',trans:'simple',target:'com.xhb.park.bean.ParkParkingPort',field:'portName', showField:'transMap.portName' },
            {name: 'plate_number', title: '车牌号码', width: '10%', align: 'center'},
            {name: 'status', title: '状态', width: '10%', align: 'center', trans: 'book', key: 'car_status', showField: 'transMap.statusName'},
            {name: 'record_type', title:'类型', width:'10%', align:'center', trans:'book', key:'record_type', showField:'transMap.record_typeName'},
            {name: 'car_type', title: '车辆类型', width: '10%', align: 'center', trans: 'book', key: 'car_type', showField: 'transMap.car_typeName'},
            {name: 'type' ,title:'数据类型', width:'10%', align:'center',trans:'book',key:'enter_or_exit',showField:'transMap.typeName'},
            {name: 'access_time', title: '进出场时间', width: '15%', align: 'center'},
            {name: 'sync_time', title: '服务器插入时间', width: '15%',trans:'simple',target:'com.xhb.pay.bean.PayCarcomeExt',field:'syncTime', align: 'center',showField: 'transMap.syncTime'},
            {name: 'update_time', title: '更新时间', width: '15%', trans:'simple',target:'com.xhb.pay.bean.PayCarcomeExt',field:'updateTime', align: 'center',showField: 'transMap.updateTime'},
            {name: 'isSyncName', title:'是否已下发', width:'10%', align:'center'},
            {name: 'remark', title: '备注', width: '10%', trans:'simple',target:'com.xhb.pay.bean.PayCarcomeExt',field:'remark', align: 'center',showField: 'transMap.remark'}
        ]
    },
    isColumnButton: function () {
        return false;
    },
    filters: function () {
        return [
            {name: 'park_id', type: 'select', url: '${path.basePath}/ms/x/parking/findListData',valuefield: 'id', textfield: 'parkName', title: '停车场',showAll:true,onSelect:'reloadPortF'},
            {name: 'port_id',type:'select',url: '${path.basePath}/ms/x/parking_port/findListData',valuefield:'id',textfield:'portName',title:'出入口',showAll:true},
            {name: 'access_time', type: 'dateBT', title: '出入场时间',isBT:true},
            {name: 'plate_number', type: 'input', title: '车牌号',filterType:'like'},
            {name: 'is_valid', title: '是否为有效数据', type: 'book', code: 'yesOrNo',showAll: true}
        ];
    },
    buttons: function () {
        return [
            {title:'修改',fun:'updateRow',permissionsCode:'pay_carcome:update',isRow:true},
            {title:'删除',fun:'deleteRow',permissionsCode:'pay_carcome:del',isRow:true},
            {title:'导出',fun:'payCarcomeExcel',permissionsCode:'pay_carcome:see',isRow:false,},
            {title:'批量导入',fun:'batchImport',permissionsCode:'pay_carcome:add'},
        ];
    },
    disableButtons: function () {
        return ["update","delete","export"];
    },
    otherFunctions: function () {
        return {
            onListPageReady: function () {
                $(".big_combo").css('cssText','width:14% !important;');
            },
            updateRow:function(row){
                if(row.status == "0"){
                    addSelectRowFun('listGrid',update);
                }else{
                    var message = "";
                    if(row.status == "1"){message = "已创建订单"}else if(row.status == "2"){message = "已支付"}
                    Ealert(message+'不可以修改噢');
                }
            },
            deleteRow:function(row){
                if(row.status == "0"){
                    pubDel('listGrid','${path.basePath}/ms/pay_carcome_history/delete/','id');
                }else{
                    var message = "";
                    if(row.status == "1"){message = "已创建订单"}else if(row.status == "2"){message = "已支付"}
                    Ealert(message+'不可以删除噢');
                }
            },
            reloadPortF:function(record){
                $('#portIdF').combobox('clear');
                $('#portIdF').combobox('reload', '${path.basePath}/ms/x/parking_port/findListData?parkId=' + record.id);
            },

            //导出
            payCarcomeExcel:function(){
                //先刷新，在用ajax提交
                reload();
                var parkIdF = $("#parkIdF").combobox('getValue');
                if(parkIdF == ""){
                    Ealert("停车场不能为空");
                    return;
                }
                setTimeout(function(){
                    $.ajax({
                        url: "${path.basePath}/ms/pay_carcome_history/payCarcomeHistoryExcel",
                        type: "post",
                        contentType: "application/json;charset=utf-8",
                        dataType: "json",
                        success: function (result) {
                            if (result.code == 400) {
                                EalertE(result.message);
                            } else {
                                Ealert("excel文件正在生成，请稍后在报表夹下载！")
                            }
                        }
                    })
                },1000);
            },
            batchImport:function(){
                openDialog('${path.basePath}/b/page-ms-park/pay_carcome_batch_import','批量导入');
            }
        }
    }
};

var add = {
    formFields: function () {
        return [
            {
                name: 'park_id', type: 'select', url: '${path.basePath}/ms/x/parking/findListData',
                valuefield: 'id', textfield: 'parkName', title: '停车场', required: true, onSelect: 'reloadPort'
            },
            {name: 'access_time', title: '进出场时间', required: true, type: 'date', formart: 'yyyy-MM-dd HH:mm:ss'},
            {name: 'port_id',type: 'select',url: '${path.basePath}/ms/x/parking_port/findListData',valuefield: 'id',textfield: 'portName',title: '出入口名称',required: true},
            {name: 'car_type', title: '车辆类型', required: true, type: 'book', code: 'car_type'},
            {name: 'sync_time', title: '服务器插入时间', required: true, type: 'date', formart: 'yyyy-MM-dd HH:mm:ss'},
            {name: 'plate_number', title: '车牌号码', type: 'input', required: true,dataType:"plate_number|plate_number_new"},
            {name: 'type', title: '出入场记录', type: 'book', code: 'enter_or_exit', required: true},
            {name: 'record_type', title: '车辆级别', type: 'book', code: 'record_type', required: true},
            {name:'img',title:'图片',type:'up',placeholder:'请上传图片'},
            {name: 'remark', title: '备注', type: 'text'},
            {name:'is_sync',type:'hide',tinyint:true}
        ];
    },
    otherFunctions: function () {
        return {
            ready: function () {

            },
            loadSuccess: function (info) {

            },
            onSave: function () {
                $('#isSync').val(0);
            },
            saveSucess: function () {
            },
            saveError: function () {

            },
            reloadPort: function (record) {
                $('#portId').combobox('clear');
                $('#portId').combobox('reload', '${path.basePath}/ms/x/parking_port/findListData?parkId=' + record.id);
            }
        }
    }
};
