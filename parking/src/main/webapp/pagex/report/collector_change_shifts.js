var modelConfig = {
    title: '交接班记录', pkey: 'id', type: 'snow', orderBy: 'end_time Desc',
    namespace: "collector_change_shifts", table: 't_collector_change_shifts', trans: true, isMultiTenant:true,db:"park",
    dp:JSON.stringify({park_id:'parkIds'})
};
var listPage = {
    listFieldSett: function () {
        return [
            {name: 'park_id',title:'停车场名称',width:'20%',trans:'simple',target:'com.xhb.park.bean.ParkParking',field:'parkName',showField:'transMap.parkName',align:'center'},
            {name: 'collector_id', title: '收费员名称', width: '15%',align: 'center',trans:'simple',target:'com.xhb.park.bean.UcenterTollCollector',field:'name',alias:'user',showField:'transMap.userName'},
            //{name: 'collector_id', title: '收费员名称2', width: '10%', align: 'center', isJoin:true, namespace:'ucenter_toll_collector', showField:'transMap.userName'},
            {name: 'start_time', title: '上班开始时间', width: '20%', align: 'center'},
            {name: 'end_time', title: '上班结束时间', width: '20%', align: 'center'},
            {name: 'status', title:'状态',width:'12%',align:'center',trans:'book',key:'shifts_status',showField:'transMap.statusName'},
            {name: 'is_sync', title:'是否已下发',width:'12%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.is_syncName'},
        ]
    },
    isColumnButton: function () {
        return false;
    },
    filters: function () {
        return [
            { name: 'park_id', type: 'select', url: '${path.basePath}/ms/x/parking/findListData', valuefield: 'id', textfield: 'parkName', title: '停车场',showAll:true},
            { name: 'collector_id', type: 'select', url: '${path.basePath}/ms/x/ucenter_toll_collector/findListData', valuefield: 'collectorId', textfield: 'name', title: '收费员名称', showAll:true}
        ];
    },
    buttons: function () {
        return [
            {title:'查看日报',fun:'showWork',permissionsCode:'collector_change_shifts:see',isRow:true},
        ];
    },
    disableButtons: function () {
        return ["view","add","update","delete"];
    },
    otherFunctions: function () {
        return {
            showWork:function(row){
                if(row.status == 0){
                    EalertE("Sorry,该收费员还未下班无法查看日报");
                    return false;
                }
                openDialog('${path.basePath}/b/page-ms-report-statement/work_report?id='+row.id,'日报');
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












