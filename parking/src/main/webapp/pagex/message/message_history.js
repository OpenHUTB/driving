var modelConfig= {title:'消息通知记录',pkey:'id',type:'snow',orderBy:'create_time Desc',
    exjs:'${path.staticPath}/js/My97DatePicker/WdatePicker.js',
    namespace:"message_history",table:'t_message_history',trans:true,db:"park",dp:JSON.stringify({park_id:'parkIds'})};
var listPage={
    listFieldSett:function(){
        return [
            {name:'park_id',title:'停车场名称',width:'19%', trans:'simple',target:'com.xhb.park.bean.ParkParking',field:'parkName',showField:'transMap.parkName',align:'center'},
            {name:'message_template_type',title:'消息分类',width:'10%',align:'center',trans:'book',key:'message_template_type',showField:'transMap.messageTemplateTypeName'},
            {name:'message_template_id', title: '消息模板', width: '10%', align: 'center', trans:'simple', target: 'com.xhb.message.bean.MessageTemplate',field:'name',alias:'template', showField: 'transMap.templateName'},
            {name:'receiver',title:'接收人',width:'10%',align:'center'},
            {name:'content',title:'内容',width:'30%',align:'center'},
            {name:'create_time',title:'发送时间',width:'10%',align:'center'},
            {name:'send_result',title:'是否成功',width:'10%',align:'center',trans:'book',key:'message_send_status',showField:'transMap.sendResultName'},

        ]},
    isColumnButton:function(){
        return  false;
    },
    filters:function(){
        return [
            {name:'park_id',type:'select',url:'${path.basePath}/ms/x/parking/findListData',
                valuefield:'id',textfield:'parkName',title:'停车场',showAll: true},
            {name:'receiver',title:'接收人',type:'input',filterType:'like'},
            {name:'message_template_type',type:'book',code:'message_template_type',title:'分类',showAll:true},
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
