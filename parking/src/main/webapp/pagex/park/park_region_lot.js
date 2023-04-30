var modelConfig= {title:'停车位',pkey:'id',type:'snow', orderBy:'update_time Desc',fkey:'inside_id',
    namespace:"park_region_lot",table:'t_park_region_lot',trans:true, db:"park",
    extendsParam:'park_id=${param.park_id}&inside_id=${param.inside_id}&region_id=${param.region_id}',
    dp:JSON.stringify({park_id:'parkIds'}),
    joinColumns:JSON.stringify({region_name:'regionName'},{lot_no:'lotNo'}),isMultiTenant:true,
};
var listPage={
    listFieldSett:function(){
        return [
            {name:'lot_no',title:'车位号',width:'15%',align:'center'},
            {name:'status',title:'车位状态',width:'15%',align:'center',trans:'book',key:'region_lot_status', showField: 'transMap.statusName'},
            {name:'start_date',title:'租赁开始日期',width:'15%',align:'center'},
            {name:'end_date',title:'租赁结束日期',width:'15%',align:'center'},
            {name: 'inside_id', title: '内部客户', width: '13%', align: 'center', trans:'pagex', key: 'pay_inside_car', showField: 'transMap.ownerName'},
            {name: 'region_id', title: '区域名称', width: '16%', align: 'center', trans:'pagex', key: 'park_region', showField: 'transMap.regionName'},
            {name:'is_sync',title:'是否已下发',width:'10%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.is_syncName'},
        ]},
    isColumnButton:function(){
        return  true;
    },
    filters:function(){
        return [
            {name:'lot_no',title:'车位号',type:'input',filterType:'like'},
            {name:'status',type:'book',title:'车位状态',code:'region_lot_status',showAll:true},
        ];
    },
    buttons:function(){
        return [
            {title:'批量导入',fun:'batchImport',permissionsCode:'park_region_lot:add'},
            {title:'查看客户',fun:'findContract',permissionsCode:'park_region_lot:see',isRow:true}
        ];
    },
    disableButtons:function(){
        return [];
    },
    otherFunctions:function(){
        return {
            batchImport:function(row){
                var parkId = "${param.park_id}";
                var regionId = "${param.region_id}";
                openDialog('${path.basePath}/b/page-ms-park/park_region_lot_batch_import?parkId='+parkId+'&regionId='+regionId,'批量导入停车位');
            },
            findContract: function(row){
                if(!row.insideId){
                    EalertE("该车位没有绑定客户,无法进行查看");
                    return;
                }
               openDialog('${path.basePath}ms/pagex/pay_inside_car_add_update.jsp?isView=true&id='+row.insideId);
            }
        }
    }
};
var add={
    formFields:function(){
        return [
            {name:'region_id',type:'select',url:'${path.basePath}/ms/x/park_region/findListData',valuefield:'id',textfield:'regionName',title:'区域名称',readonly:true},
            {name: 'lot_no', title: '车位号', required: true, type: 'input'},
            {name: 'hardware_sn', title: '地磁序列号',  type: 'input'},
            {type:'divStart',id:'extInfoDiv'},
            {name: 'status', title: '车位状态', type:'book',code:'region_lot_status'},
            {name: 'start_date', title: '租赁开始日期', type: 'date'},
            {name: 'end_date', title: '租赁结束日期',  type: 'date'},
            {name: 'plate_number', title: '车牌号',  type: 'input'},
            {type:'divEnd'},
            {name:'is_sync',type:'hide'},
            {name:'park_id',type:'hide', title: '停车场ID'},
            {name:'inside_id',type:'hide', title: '内部客户ID'},
        ];
    },
    otherFunctions:function(){
        return {
            ready:function(){
                $("#Div").hide();
                $('#status').combobox("select","0");
                var parkId = "${param.park_id}";
                $('#parkId').val(parkId);
                var insideId = "${param.inside_id}";
                $('#insideId').val(insideId);
                var regionId = "${param.region_id}";
                $('#regionId').combobox("setValue",regionId);
            },
            loadSuccess:function(info){
                if(info.monthlyType != 2){
                    $("#extInfoDiv").show();
                    renderView("extInfoDiv");
                }
            },
            onSave:function(){
                $('#isSync').val(0);
            },
            saveSucess:function(){
            },
            saveError:function(){
            },
        }
    }
}
