var modelConfig= {title:'各时间段费用计算结果',pkey:'id',type:'snow',
    orderBy:'start_time asc',
    namespace:"pay_temp_order_fee_depict",table:'t_pay_temp_order_fee_depict',trans:true,extendsParam:'fee_day_id=${param.fee_day_id}'};
var listPage={
    listFieldSett:function(){
	  return [
        {name:'start_time',title:'开始时间',width:'25%',align:'center'},
        {name:'end_time',title:'结束时间',width:'25%',align:'center'},
        {name:'price',title:'单价',width:'25%',align:'center'},
        {name:'total_amount',title:'总价格',width:'24%',align:'center'},
    ]},
    isColumnButton:function(){
	  return  true;
  },
  filters:function(){
      return [
	 ];
  },
  buttons:function(){
      return [];
  },
  disableButtons:function(){
	  return ["view","add","update","delete"];
  },
  otherFunctions:function(){
      return {
        onListPageReady:function(){
            $('.searchBTN').hide();
        },
	  }
  }
};
var add={
	formFields:function(){
	     return [
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
