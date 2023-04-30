var modelConfig= {title:'',pkey:'id',type:'snow',
    orderBy:'update_time Desc',db:"park",dp:JSON.stringify({park_id:'parkIds'}),
    namespace:"park_special_pass_type",table:'t_park_special_pass_type',trans:true,extendsParam:'park_id=${param.park_id}',joinColumns:JSON.stringify({describ:'typeDescrib'})};
var listPage={
    listFieldSett:function(){
	  return [
        {name:'describ',title:'描述',width:'34%',align:'center'},
        {name:'is_disable',title:'是否启用',width:'15%',formart:'formatRowColor',align:'center',trans:'book',key:'is_disable',showField:'transMap.is_disableName'},
        {name:'is_sync',title:'是否已下发',width:'15%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.is_syncName'},
        {name:'create_user',title:'创建人',width:'15%',align:'center',trans:'sysUser',showField:'transMap.create_userUserName'},
        {name:'create_time',title:'创建时间',width:'20%',align:'center'},
    ]},
    isColumnButton:function(){
	  return  true;
  },
  filters:function(){
      return [
          {name:'is_disable',title:'是否启用',type:'book',code:'is_disable',showAll:true},
          {name: 'describ', type: 'input', title: '描述', filterType: 'like' }
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
          setExcelName:function () {
              return "特殊放行原因列表";
          }
	  }
  }
};
var add={
	formFields:function(){
	     return [
            {name:'describ',title:'描述',type:'bigInput',required:true, dataType: 's1-32'},
            {name:'is_disable',title:'是否启用',type:'book',code:'is_disable',required:true,dftVal:0},
            {name:'park_id',type:'hide'},
            {name:'is_sync',title:'是否同步',type:'hide'},
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

//给前段用户的接口
// inF代表哪些字段需要返回给前段
// outF代表除了哪些字段要返回给前段
// where 后面支持哪些参数
var front ={
    apis:function(){return [
        {name:'list',type:'list',inF:'parkId,describ,id',jsonp:'false',where:'parkId'},
 ]}};
