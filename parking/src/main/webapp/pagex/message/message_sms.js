var modelConfig= {title:'短信通知记录',pkey:'id',type:'snow',orderBy:'create_time Desc',
    exjs:'${path.staticPath}/js/My97DatePicker/WdatePicker.js',
    namespace:"message_sms",table:'t_message_sms_record',trans:true,db:"park",dp:JSON.stringify({park_id:'parkIds'}),isMultiTenant:true};
var listPage={
    listFieldSett:function(){
        return [
            {name:'park_id',title:'停车场名称',width:'20%',trans:'pagex',key:'parking',showField:'transMap.parkName',align:'center'},
            {name:'cus_name',title:'短信接收人',width:'20%',align:'center'},
            {name:'mobile',title:'电话',width:'20%',align:'center'},
            {name:'message_type',title:'短信类型',width:'20%',align:'center',trans:'book',key:'message_type',showField:'transMap.message_typeName'},
            {name:'group_code',title:'集团编号',width:'19%',align:'center'},
        ]},
    isColumnButton:function(){
        return  false;
    },
    filters:function(){
        return [
            {name:'park_id',type:'select',url:'${path.basePath}/ms/x/parking/findListData',
                valuefield:'id',textfield:'parkName',title:'停车场',showAll: true},
            {name: 'create_time', type: 'dateBT', title: '日期', isBT:true},
        ];
    },
    buttons: function () {
        return [

        ];
    },
    disableButtons: function () {
        return ["view","add","update","delete","export"];
    },
    otherFunctions: function(){
        return {

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
