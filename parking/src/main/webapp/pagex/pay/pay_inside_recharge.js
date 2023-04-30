var modelConfig= {title:'',pkey:'id',type:'snow',orderBy:'update_time Desc',
    namespace:"pay_inside_recharge",table:'t_pay_inside_recharge',trans:true, isMultiTenant: true,
    exjs:'${path.staticPath}/js/My97DatePicker/WdatePicker.js',saveUrl:'${path.basePath}/ms/pay_inside_recharge/rechargeAdd',
    extendsParam:'inside_id=${param.inside_id}&park_id=${param.park_id}',db:"park",dp:JSON.stringify({park_id:'parkIds'})
};
var listPage={
    listFieldSett:function(){
        return [
            {name: 'create_time', title: '续费时间',width:'15%',align:'center'},
            {name: 'amount', title:'续费金额',width:'10%',align:'center'},
            {name: 'give_amount', title: '赠送金额',width:'10%',align:'center'},
            {name: 'is_contract', title: '是否是月租户续费',width:'10%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.is_contractName'},
            {name:'remark',title:'备注',width:'34%',align:'center'},
            {name:'create_user',title:'操作人',width:'10%',align:'center',trans:'user',showField:'transMap.create_userUserName'},
            {name:'is_sync',title:'是否已下发',width:'10%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.is_syncName'},
        ]},
    isColumnButton:function(){
	  return  true;
  },
  filters:function(){
      return [
          {name:'is_contract',type:'book',title:'是否是月租户续费',code:'yesOrNo'},
          {name: 'create_time', type: 'dateBT', title: '续费时间',isBT:true},
      ];
  },
  buttons:function(){
      return [];
  },
  disableButtons:function(){
	    return ["add","update","delete"];
  },
  otherFunctions:function(){
      return {
          setExcelName:function () {
              return "续费记录列表";
          },
	  }
  }
};
var add={
	formFields:function(){
        return [
            {name:'inside_id',type:'hide',title:'内部用户',required:true},
            {name:'park_id',type:'hide',title:'停车场',required:true},
            {type:'divStart',id:'ownerInfoDiv',style:'display:none;'},
            {class:'owner_name',type:'input',title:'车主名称'},
            {class:'owner_mobile',type:'input',title:'车主电话'},
            {class:'plate_nums',type:'input',title:'车牌号'},
            {class:'create_time',type:'input',title:'创建时间'},
/*            {class:'room_num',type:'input',title:'房间号'},*/
            {class:'lease_type',type:'input',title:'月租户类型'},
            {class:'monthly_type_name',type:'input',title:'租赁类型'},
            {type:'divEnd'},
            {name:'amount',title:'续费金额',type:'input',required:true, dataType: 'n1-6|double2'},
            {name:'give_amount',title:'赠送金额',type:'input', dataType: 'n1-5|double2'},
            {name:'remark',title:'备注',type:'text',placeholder:'多行文本'},
            {name:'is_contract',title:'是否是月租户续费',type:'hide'},
            {name:'is_sync',type:'hide'},
         ];
	},
    otherFunctions:function(){
      return {
	    ready:function(){
            if('${param.isAdd}' == 'true'){
                $('#giveAmount').val(0);
                $('#isContract').val(0);
                $("#insideId").val('${param.inside_id}');
                $("#parkId").val('${param.park_id}');
                $('.owner_mobile').val('${param.owner_mobile}');
                $('.owner_name').val('${param.owner_name}');
                $('.room_num').val('${param.room_num}');
                $('.plate_nums').val('${param.plate_nums}');
                $('.create_time').val('${param.create_time}');
                $('.lease_type').val('${param.lease_type}');
                $('.monthly_type_name').val('${param.monthly_type_name}');
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
