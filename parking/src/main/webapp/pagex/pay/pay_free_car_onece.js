var modelConfig= {title:'一次性免费车',pkey:'id',type:'snow',
    orderBy:'update_time Desc',db:"park",dp:JSON.stringify({park_id:'parkIds'}),
    namespace:"pay_free_car_onece",table:'t_pay_free_car_onece',trans:true,isMultiTenant:true};
var listPage={
    listFieldSett:function(){
        return [
            {name:'park_id',title:'停车场名称',width:'15%',trans:'pagex',key:'parking',showField:'transMap.parkName',align:'center'},
            {name:'plat_number',title:'车牌号',width:'15%',align:'center'},
            {name:'radio',title:'减免比例',width:'15%',align:'center'},
            {name:'is_used',title:'是否已使用',width:'15%',align:'center',trans: 'book',key: 'yesOrNo',showField: 'transMap.is_usedName'},
            {name:'remark',title:'备注',width:'39%',align:'center'},
        ]},
    isColumnButton:function(){
        return  true;
    },
    filters:function(){
        return [
            {name: 'park_id', type: 'select', url: '${path.basePath}/ms/x/parking/findListData',
                valuefield: 'id', textfield: 'parkName', title: '停车场',showAll:true},
            {name:'plat_number',title:'车牌号',type:'input',filterType:'like'},
            {name:'is_used',title:'是否已使用',type:'book',code:'yesOrNo',showAll:true},
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
            {name: 'park_id', type: 'select', url: '${path.basePath}/ms/x/parking/findListData',
                valuefield: 'id', textfield: 'parkName', title: '停车场', required: true
            },
            {name:'plat_number',title:'车牌号',type:'input',required:true,dataType:"plate_number|plate_number_new"},
            {name:'radio',title:'减免比例',type:'input',required:true,dataType:"n",placeholder:"请输入1-100的整数"},
            {name:'apply_user',title:'申请人',type:'input',required:true},
            {name:'remark',title:'备注',type:'text'},
            {name: 'is_sync',type:'hide'},
            {name: 'is_used',type:'hide'}

        ];
    },
    otherFunctions:function(){
        return {
            ready:function(){
                $('#radio').val(100);
            },
            loadSuccess:function(info){

            },
            onSave:function(){
                $('#isUsed').val(0);
                $('#isSync').val(0);
            },
            saveSucess:function(){
            },
            saveError:function(){

            },
        }
    }
}
