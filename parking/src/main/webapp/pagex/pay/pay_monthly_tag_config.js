var modelConfig= {title:'月租户标签配置',pkey:'id',type:'snow',
    orderBy:'update_time Desc',namespace:"pay_monthly_tag_config",table:'t_pay_monthly_tag_config',trans:true,db:"park",dp:JSON.stringify({park_id:'parkIds'}),
    joinColumns:JSON.stringify({tag_name:'tagName'}),isMultiTenant:true,extendsParam:'park_id=${param.park_id}'};
var listPage={
    listFieldSett:function(){
        return [
            {name:'tag_name',title:'标签名',width:'30%',align:'center'},
            {name:'create_time',title:'创建时间',width:'39%',align:'center'},
            {name:'create_user',title:'创建人',width:'30%',align:'center',trans:'sysUser',showField:'transMap.create_userUserName'},
        ]},
    isColumnButton:function(){
        return  true;
    },
    filters:function(){
        return [
            {name:'tag_name',title:'标签名',type:'input',filterType:'like'},
        ];
    },
    buttons:function(){
        return [];
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
            {name:'park_id',type:'hide'},
            {name:'tag_name',title:'月租户标签名',type:'input',required:'true'},
        ];
    },
    otherFunctions:function(){
        return {
            ready:function(){
            },
            loadSuccess:function(info){

            },
            onSave:function(){
                $('#parkId').val('${param.park_id}');
            },
            saveSucess:function(){
            },
            saveError:function(){
            },
        }
    }
}
