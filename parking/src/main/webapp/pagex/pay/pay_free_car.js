var modelConfig= {title:'免费车',pkey:'id',type:'snow',
    orderBy:'update_time Desc',
    namespace:"pay_free_car",table:'t_pay_free_car',trans:true,db:"park",dp:JSON.stringify({park_id:'parkIds'}),isMultiTenant:true};
var listPage={
    listFieldSett:function(){
        return [
            {name:'plate_number',title:'车牌号',width:'18%',align:'center'},
            {name:'free_type',title:'免费类型',width:'18%',align:'center',trans:'book',key:'free_type',showField:'transMap.free_typeName'},
            {name:'park_id',title:'停车场名称',width:'18%',trans:'pagex',key:'parking',showField:'transMap.parkName',align:'center'},
            {name:'remark',title:'备注',width:'31',align:'center'},
            {name:'is_sync',title:'是否已下发',width:'15%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.is_syncName'},
        ]},
    isColumnButton:function(){
        return  true;
    },
    filters:function(){
        return [
            {name:'plate_number',type:'input',title:'车牌号',filterType:'like'},
            {name:'park_id',type:'select',url:'${path.basePath}/ms/x/parking/findListData',valuefield:'id',textfield:'parkName',title:'停车场',showAll:true}
        ];
    },
    buttons:function(){
        return [];
    },
    disableButtons:function(){
        return [];
    },
    otherFunctions:function(){
        return {};
    }
};
var add= {
    formFields: function () {
        return [
            {name: 'free_type', type: 'input', title: '免费类型',type:'book',code:'free_type',required: true},
            {name: 'plate_number', type: 'input', title: '车牌号', required: true},
            {name: 'park_id',type:'select',url:'${path.basePath}/ms/x/parking/findListData',valuefield:'id',textfield:'parkName',title:'停车场名称',required:true},
            {name:'remark',title:'备注',type:'text'},
            {name: 'is_sync',type:'hide'}
        ];
    },
    otherFunctions: function () {
        return {
            ready: function () {},
            loadSuccess: function (info) {},
            onSave: function () { $('#isSync').val(0);},
            saveSucess: function () {},
            saveError: function () {}
        }
    }
};
