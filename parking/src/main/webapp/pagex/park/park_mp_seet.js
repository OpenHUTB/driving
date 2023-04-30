var modelConfig= {title:'微信公众号配置',pkey:'id',type:'snow',orderBy:'update_time Desc',
    namespace:"park_mp_seet",table:'t_park_mp_seet',trans:true,db:"park"};
var listPage={
    listFieldSett:function(){
        return [
            {name:'name',title:'公众号名称',width:'25%',align:'center'},
            {name:'app_id',title:'微信登录appId',width:'25%',align:'center'},
            {name:'secret',title:'微信登录secret',width:'25%',align:'center'},
            {name:'create_time',title:'创建时间',width:'24%',align:'center'},
        ]},
    isColumnButton:function(){
        return  false;
    },
    filters:function(){
        return [
            {name:'name',type:'input',title:'公众号名称',filterType:'like'},
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
        return {}
    }
};
var add={
    formFields:function(){
        return [
            {name:'app_id', title:'微信登录appId', type:'input', request:true},
            {name:'secret', title:'微信登录secret', type:'input', request:true},
            {name:'name', title:'公众号名称', type:'input', request:true},
            {name:'park_ids', type:'select', url:'${path.basePath}/ms/parking/getParkList',
                valuefield:'parkId', textfield:'parkName', title:'停车场', multiple:true},
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
