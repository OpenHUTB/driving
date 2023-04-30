modelConfig= {title:'商户余额充值记录',pkey:'id',type:'uuid',orderBy:'update_time Desc',
    namespace:"business_balance_recharge_log",table:'t_business_balance_recharge_log',trans:true, isMultiTenant: true,
    exjs:'${path.staticPath}/js/My97DatePicker/WdatePicker.js',saveUrl:'${path.basePath}/ms/business_merchant/balanceRecharge',
    extendsParam:'park_id=${param.park_id}&merchant_id=${param.merchant_id}'
};
var listPage={
    listFieldSett:function(){
        return [
            {name: 'create_time', title: '充值时间',width:'25%',align:'center'},
            {name: 'recharge_money', title:'充值金额',width:'25%',align:'center'},
            {name: 'give_money', title: '赠送金额',width:'25%',align:'center'},
            {name:'create_user',title:'操作人',width:'25%',align:'center',trans:'user',showField:'transMap.create_userUserName'},
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
            {name:'group_code',type:'hide',title:'集团编码',required:true},
            {name:'park_id',type:'hide',title:'停车场',required:true},
            {name:'merchant_id',type:'hide',title:'商户id',required:true},
            {name:'balance',type:'hide',title:'商户余额'},
            {type:'divStart',id:'ownerInfoDiv',style:'display:none;'},
            {class:'merchant_name',type:'input',title:'商家名称'},
            {class:'contact_mobile',type:'input',title:'联系电话'},
            {class:'balance',type:'input',title:'商户余额'},
            {class:'merchant_address',type:'input',title:'商家地址'},
            {type:'divEnd'},
            {name:'recharge_money',title:'充值金额',type:'input',required:true, dataType: 'n1-6|double2'},
            {name:'give_money',title:'赠送金额',type:'input', dataType: 'n1-5|double2'},
         ];
	},
    otherFunctions:function(){
      return {
	    ready:function(){
            if('${param.isAdd}' == 'true'){
                $("#parkId").val('${param.park_id}');
                $('#merchantId').val('${param.merchant_id}');
                $('.merchant_name').val('${param.merchant_name}');
                $('.contact_mobile').val('${param.contact_mobile}');
                $('.merchant_address').val('${param.merchant_address}');
                if('${param.balance}'==null || '${param.balance}'=='' || '${param.balance}'=='null'){
                    $('#balance').val(0);
                    $('.balance').val(0);
                }else{
                    $('.balance').val('${param.balance}');
                    $('#balance').val('${param.balance}');
                }

                $('#ownerInfoDiv').show();
                renderView("ownerInfoDiv");
            }
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