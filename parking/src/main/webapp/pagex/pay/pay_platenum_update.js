var modelConfig= {title:'修改车牌号',pkey:'id',type:'snow',orderBy:'update_time Desc',
    namespace:"pay_platenum_update",table:'t_pay_platenum_update',trans:true,db:"park"};
var listPage={
    listFieldSett:function(){
        return [
            {name:'park_id',title:'停车场名称',width:'15%',align:'center',trans:'pagex',key:'parking',showField:'transMap.parkName'},
            {name:'old_plate_num',title:'修改前车牌号码',width:'15%',align:'center'},
            {name:'new_plate_num',title:'修改后车牌号码',width:'15%',align:'center'},
            {name:'collector_id',title:'收费员',width:'15%',align:'center',trans:'pagex',key:'ucenter_toll_collector',showField:'transMap.userName'},
            {name:'remark',title:'备注',width:'24%',align:'center'},
            {name:'create_time',title:'创建时间',width:'15%',align:'center'},
        ]},
    isColumnButton:function(){
        return  true;
    },
    filters:function(){
        return [
            {name:'park_id',type:'select',url:'${path.basePath}/ms/x/parking/findListData?isDisable=0', valuefield:'id',textfield:'parkName',title:'停车场',showAll:true,onSelect:'reloadCollector'},
            {name:'collector_id',title:'收费员',type:'select',url:'${path.basePath}/ms/x/ucenter_toll_collector/findListData',valuefield:'collectorId',textfield:'name'},
        ];
    },
    buttons:function(){
        return [];
    },
    disableButtons:function(){
        return ['add','update','delete'];
    },
    otherFunctions:function(){
        return {
            reloadCollector:function(record){
                $('#collectorIdF').combobox('clear');
                $('#collectorIdF').combobox('reload','${path.basePath}/ms/x/ucenter_toll_collector/findListData?parkId=' + record.id);
            }
        }
    }
};
var add={
    formFields:function(){
        return [
            {name:'park_id',type:'select',url:'${path.basePath}/ms/x/parking/findListData',valuefield:'id',textfield:'parkName',title:'停车场'},
            {name:'collector_id',title:'收费员',type:'select',url:'${path.basePath}/ms/x/ucenter_toll_collector/findListData',valuefield:'collectorId',textfield:'name'},
            {name:'old_plate_num',title:'修改前车牌号码',type:'input'},
            {name:'new_plate_num',title:'修改后车牌号码',type:'input'},
            {name:'create_time',title:'创建时间',type:'date'},
            {name:'remark',title:'备注',type:'text'},
        ];
    },
    otherFunctions:function(){
        return {
            ready:function(){
            },
            loadSuccess:function(info){

            },
            onSave:function(){

            },
            saveSucess:function(){
            },
            saveError:function(){

            },
        }
    }
}
