var modelConfig= {title:'短信模板管理',pkey:'id',type:'snow',orderBy:'create_time Desc',
    namespace:"sms_mould",table:'t_message_sms_config',trans:true,db:"park",};

var listPage={
    listFieldSett:function(){
        return [
            {name:'sign',title:'短信签名',width:'25%',align:'center'},
            {name:'template_id',title:'模板id',width:'25%',align:'center'},
            {name:'message_type',title:'短信类型',width:'25%',align:'center',trans:'book',key:'message_type',showField:'transMap.message_typeName'},
        ]},

    isColumnButton:function(){
        return  false;
    },
    filters:function(){
        return [
        ];
    },
    buttons:function(){
        return [

        ];
    },
    disableButtons:function(){
        return [];
    },
    otherFunctions:function(){
        return {

        }
    }
};
var add={
    formFields:function(){
        return [
            {name:'sign',title:'短信签名',required:true,type:'input'},
            {name:'template_id',title:'模板id',required:true,type:'input'},
            {name:'message_type',title:'短信类型',type:'book',code:'message_type'},
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
            getConflictMsg:function(){
            },
            saveError:function(){

            },
        }
    }
}

