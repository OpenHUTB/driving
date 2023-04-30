var modelConfig= {title:'商户余额变动记录',pkey:'id',type:'uuid',orderBy:'update_time Desc',
    namespace:"business_balance_change_log",table:'t_business_balance_change_log',trans:true, isMultiTenant: true,
    exjs:'${path.staticPath}/js/My97DatePicker/WdatePicker.js',
    extendsParam:'park_id=${param.park_id}&merchant_id=${param.merchant_id}'
};
var listPage={
    listFieldSett:function(){
        return [
            {name: 'create_time', title: '变动时间',width:'15%',align:'center'},
            {name: 'change_money', title:'变动金额',width:'10%',align:'center'},
            {name: 'change_type', title: '变动类型',width:'10%',align:'center',trans:'book',key:'business_balance_change',showField:'transMap.change_typeName'},
            {name: 'reason', title:'变动原因',width:'15%',align:'center'},
            {name: 'reason_type', title: '原因类型',width:'15%',align:'center',trans:'book',key:'business_balance_reason',showField:'transMap.reason_typeName'},
            {name:'create_user',title:'操作人',width:'15%',align:'center',trans:'user',showField:'transMap.create_userUserName'},
            {name: 'remarks', title:'备注',width:'20%',align:'center'},
        ]},
    isColumnButton:function(){
	  return  true;
  },
  filters:function(){
      return [
          {name: 'create_time', type: 'dateBT', title: '充值时间',isBT:true},
      ];
  },
  buttons:function(){
      return [];
  },
  disableButtons:function(){
	    return ["add","update","delete","view"];
  },
  otherFunctions:function(){
      return {
	  }
  }
};
var add={
	formFields:function(){
        return [

            {name:'create_time',type:'input',title:'变动时间'},
            {name:'change_money',type:'input',title:'变动金额'},
            {name: 'change_type', title: '变动类型', type: 'book', code: 'business_balance_change'},
            {name:'reason',type:'input',title:'变动原因'},
            {name: 'reason_type', title: '原因类型', type: 'book', code: 'business_balance_reason'},
            {name:'remarks',title:'备注',type:'input'},
         ];
	},
    otherFunctions:function(){
      return {
	    ready:function(){

	    },
	    loadSuccess:function(info){

	    },
	    onSave:function(){
            $('#isSync').val(0);
	    },
		saveSucess:function(){
	    },
		saveError:function(){

	    },
	  }
   }
}