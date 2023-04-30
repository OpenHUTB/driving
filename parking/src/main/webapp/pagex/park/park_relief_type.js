var modelConfig= {title:'减免分类',pkey:'id',type:'snow', orderBy:'update_time Desc', db:"park", dp:JSON.stringify({park_id:'parkIds'}),
    namespace:"park_relief_type",table:'t_park_relief_type',trans:true,isMultiTenant:true,
    extendsParam:'park_id=${param.park_id}',
};
var listPage={
    listFieldSett:function(){

        return [
            {name:'name',title:'减免分类名称',width:'15%',align:'center'},
            {name:'amount',title:'减免金额',width:'15%',align:'center'},
            {name:'create_user',title:'创建人',width:'15%',align:'center',trans:'sysUser',showField:'transMap.create_userUserName'},
            {name:'create_time',title:'创建时间',width:'15%',align:'center'},
            {name:'create_user',title:'修改人',width:'15%',align:'center',trans:'sysUser',showField:'transMap.create_userUserName'},
            {name:'create_time',title:'修改时间',width:'15%',align:'center'},
            {name:'is_sync',title:'是否已下发',width:'9%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.is_syncName'},
        ]},
    isColumnButton:function(){
        return  true;
    },
    filters:function(){
        return [
            {name: 'name', type: 'input', title: '减免分类名称', filterType: 'like' }
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
            {name:'name',title:'减免分类名称',type:'input',required:true, dataType: 's1-32'},
            {name:'amount',title:'减免金额',type:'input',required:true, dataType: 'n1-5'},
            {name:'park_id',type:'hide'},
            {name:'is_sync',type:'hide'},
        ];
    },
    otherFunctions:function(){
        return {
            ready:function(){
                $("#parkId").val("${param.park_id}");
            },
            loadSuccess:function(info){
            },
            onSave:function(){
                $("#isSync").val(0);
            },
            saveSucess:function(){
            },
            saveError:function(){

            },
        }
    }
}
