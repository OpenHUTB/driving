var modelConfig= {title:'消息通知记录',pkey:'id',type:'snow',orderBy:'create_time Desc',
    exjs:'${path.staticPath}/js/My97DatePicker/WdatePicker.js',
    namespace:"message_template",table:'t_message_template',trans:true,db:"park",dp:JSON.stringify({park_id:'parkIds'})};
var listPage={
    listFieldSett:function(){
        return [
            {name:'name',title:'模板名称',width:'15%',align:'center'},
            {name:'type',title:'分类',width:'10%',align:'center',trans: 'book',key: 'message_notice_type',showField: 'transMap.typeName'},
            {name:'content',title:'内容',width:'60%',align:'center'},
            {name:'remark',title:'备注',width:'15%',align:'center'}
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
