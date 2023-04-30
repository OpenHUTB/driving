var modelConfig= {title:'临时优惠规则',pkey:'id',type:'snow',orderBy:'update_time Desc',
    namespace:"park_temp_discount",table:'t_park_temp_discount',trans:true,db:"park",dp:JSON.stringify({park_id:'parkIds'}),isMultiTenant:true};
var listPage={
    listFieldSett:function(){
	  return [
          {name:'park_id',title:'停车场名称',width:'15%',trans:'pagex',key:'parking',showField:'transMap.parkName',align:'center'},
        {name:'discount_name',title:'优惠名称',width:'10%',align:'center'},
        {name:'start_date',title:'生效日期',width:'10%',align:'center'},
        {name:'end_date',title:'失效日期',width:'10%',align:'center'},
        {name:'car_type',title:'车辆类型',width:'10%',align:'center',trans:'book',key:'car_type',showField:'transMap.car_typeName'},
        {name:'discount_amount',title:'优惠金额',width:'10%',align:'center',dataType:'double2'},
          {name:'is_disable',title:'是否禁用',width:'8%',formart:'formatRowColor',align:'center',trans:'book',key:'is_disable',showField:'transMap.is_disableName'},
        {name:'create_time',title:'创建时间',width:'10%',align:'center'},
        {name:'create_user',title:'创建人',width:'10%',align:'center',trans:'sysUser',showField:'transMap.create_userUserName'},
          {name:'is_sync',title:'是否下发',width:'6%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.is_syncName'},
      ]},
    isColumnButton:function(){
	  return  true;
  },
  filters:function(){
      return [
          {name:'park_id',type:'select',url:'${path.basePath}/ms/x/parking/findListData',valuefield:'id',textfield:'parkName',title:'停车场',showAll:true},
          {name:'is_disable',type:'book',code:'is_disable',title:'是否禁用',showAll:true},
          {name:'discount_name',title:'优惠名称',type:'input',filterType:'like'},
	 ];
  }, 
  buttons:function(){
      return [];
  },
  disableButtons:function(){
	    return ["export","delete"];
  },
  otherFunctions:function(){
      return {
	  }		
  }
}; 
var add={ 
	formFields:function(){
	     return [
	         {name:'park_id',type:'select',url:'${path.basePath}/ms/x/parking/findListData',valuefield:'id',textfield:'parkName',title:'停车场',required:true},
            {name:'discount_name',title:'优惠名称',type:'input',required:true},
            {name:'start_date',title:'生效日期',type:'date',formart: 'yyyy-MM-dd',placeholder:'请选择生效日期',required:true},
            {name:'end_date',title:'失效日期',type:'date',formart: 'yyyy-MM-dd',placeholder:'请选择失效日期',required:true},
            {name:'car_type',title:'车辆类型',type:'book',code:'car_type',required:true},
             {name:'discount_amount',title:'优惠金额',type:'input',required:true},
             {name:'match_rule',title:'匹配规则',type:'book',code:'match_rule'},
            {name:'match_regular',title:'匹配正则',type:'input'},
            {name:'test_plate_num',title:'测试车牌号',type:'input'},
            {name:'is_disable',title:'是否禁用',type:'switch'},
             {name:'is_sync',title:'是否下发',type:'hide'},
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
