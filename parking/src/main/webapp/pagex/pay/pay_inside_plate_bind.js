var modelConfig= {title:'内部车和车牌号绑定记录',pkey:'id',type:'snow',fkey:'inside_id',
    orderBy:'update_time Desc',namespace:"pay_inside_plate_bind",table:'t_pay_inside_plate_bind',trans:true,extendsParam:'inside_id=${param.inside_id}&park_id=${param.park_id}',
    saveUrl:'${path.basePath}/ms/pay_inside_plate_bind/plateBindAdd',updateUrl:'${path.basePath}/ms/pay_inside_plate_bind/plateBindUpdate?id=',isMultiTenant:true,
    delUrl:'${path.basePath}/ms/pay_inside_plate_bind/plateBindDel',db:"park",dp:JSON.stringify({park_id:'parkIds'}),
    };
var listPage={
    listFieldSett:function(){
	  return [
	    {name:'park_id',title: "停车场名称",hidden:true},
        {name:'plate_number',title:'车牌号',width:'20%',align:'center'},
        {name:'is_sync',title:'是否已下发',width:'20%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.is_syncName'},
        {name:'create_user',title:'创建人',width:'20%',align:'center',trans:'sysUser',showField:'transMap.create_userUserName'},
        {name:'create_time',title:'创建时间',width:'20%',align:'center'},
        {name:'remark',title:'备注',width:'19%',align:'center'},
    ]},
    isColumnButton:function(){
	  return  true;
  },
  filters:function(){
      return [
        {name:'plate_number',title:'车牌号',type:'input',filterType:'like'},
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
      return {

	  }
  }
};

var add={
	formFields:function(){
	     return [
	        {name:'park_id',title:'停车场id',type:'hide',required:true},
	        {name:'inside_id',title:'内部车id',type:'hide',required:true},
            {name:'plate_number',title:'车牌号',type:'input',required:true,one2x:true},
            {name:'remark',title:'备注',type:'input',one2x:true},
            {name:'is_sync',type:'hide'}
		 ];
	},
    otherFunctions:function(){
      return {
	    ready:function(){
	        $("#insideId").val("${param.inside_id}");
	        $("#parkId").val("${param.park_id}");
	    },
	    loadSuccess:function(info){

	    },
        getConflictMsg:function(){
            return '同一个停车场内车牌号不能重复绑定';
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
