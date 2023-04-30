var modelConfig= {title:'网关差错账记录',pkey:'id',type:'snow',extendsParam:'task_id=${param.task_id}',
    orderBy:'update_time Desc',namespace:"pay_gateway_bill_log",table:'t_pay_gateway_bill_log',trans:true};
var listPage={
    listFieldSett:function(){
	  return [
        {name:'order_no',title:'停车场系统订单号',width:'15%',align:'center'},
        {name:'pay_order_no',title:'第三方支付订单号',width:'15%',align:'center'},
        {name:'type',title:'类型',width:'10%',align:'center',trans:'book',key:'errorBill_type',showField:'transMap.typeName'},
        {name:'swiftpass_order_no',title:'威富通订单号',width:'15%',align:'center'},
        {name:'remark',title:'备注',width:'34%',align:'center'},
        {name:'is_handle',title:'是否已经处理',width:'10%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.is_handleName'},
    ]},
    isColumnButton:function(){
	  return  true;
  },
  filters:function(){
      return [
        {name:'type',title:'类型',type:'book',code:'errorBill_type'},
        {name:'order_no',title:'停车场系统订单号',type:'input',filterType:'like'},
        {name:'pay_order_no',title:'第三方支付订单号',type:'input',filterType:'like'},
        {name:'swiftpass_order_no',title:'威富通订单号',type:'input',width:'10%',filterType:'like'},
	 ];
  },
  buttons:function(){
      return [
        {title:'处理',fun:'updateHandleStatus',permissionsCode:'pay_gateway_bill_log:update',isRow:true},
      ];
  },
  disableButtons:function(){
	    return ['delete','add','update'];
  },
  otherFunctions:function(){
      return {
        updateHandleStatus:function(record){
            if(record.isHandle == "1"){
                EalertE('差错账为已处理状态');
                return false;
            }
            $.ajax({
    　　　　　　url:'${path.basePath}/ms/x/pay_gateway_bill_log/update/'+record.id,
    　　　　　　data:{"isHandle":"1"},
    　　　　　　type:'POST',
               dataType: 'json',
    　　　　　　success:function(res){
                    Ealert("是否处理状态修改成功");
                    reload();
    　　　　　　},
    　　　　　　error:function (res){
                    EalertE("是否处理状态修改失败");
    　　　　　　}
    　　　　});
        }
	  }
  }
};
var add={
	formFields:function(){
	     return [
            {name:'order_no',title:'停车场系统订单号',type:'input'},
            {name:'pay_order_no',title:'第三方支付订单号',type:'input'},
            {name:'type',title:'类型1 威富通丢单  2 金额不一致 3 停车系统丢单',type:'book',code:'type'},
            {name:'is_handle',title:'是否已经处理',type:'book',code:'is_handle'},
            {name:'swiftpass_order_no',title:'威富通订单号',type:'input'},
            {name:'task_id',title:'对账任务id',type:'input'},
            {name:'remark',title:'备注',type:'text'},
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
