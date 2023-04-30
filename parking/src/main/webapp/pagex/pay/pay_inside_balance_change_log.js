var modelConfig= {title:'',pkey:'id',type:'snow',
    orderBy:'update_time Desc',db:"park",dp:JSON.stringify({park_id:'parkIds'}),
    namespace:"pay_inside_balance_change_log",table:'t_pay_inside_balance_change_log',trans:true,extendsParam:'inside_id=${param.inside_id}'};
var listPage={
    listFieldSett:function(){
	  return [
        {name:'type',title:'余额变动类型',width:'10%',align:'center',trans:'book',key:'balance_change_type',showField:'transMap.typeName'},
        {name:'is_add',title:'是否是充值金额',width:'10%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.is_addName'},
        {name:'amount',title:'金额',width:'10%',align:'center'},
        {name:'remark',title:'备注',width:'39%',align:'center'},
        {name:'create_time',title:'创建时间',width:'10%',align:'center'},
        {name:'create_user',title:'操作人',width:'10%',align:'center',trans:'user',showField:'transMap.create_userUserName'},
        {name:'is_sync',title:'是否已下发',width:'10%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.is_syncName'},
    ]},
  isColumnButton:function(){
      return  true;
  },
  filters:function(){
      return [
        {name:'type',title:'余额变动类型',type:'book',code:'balance_change_type'},
        {name:'is_add',title:'是否是充值金额',type:'book',code:'yesOrNo'},
	 ];
  },
  buttons:function(){
      return [];
  },
  disableButtons:function(){
	    return ['update','add','delete'];
  },
  otherFunctions:function(){
      return {
          setExcelName:function () {
              return "账单变动列表";
          }
	  }
  }
};
var add={
	formFields:function(){
	     return [
            {name:'type',title:'余额变动类型',type:'book',code:'balance_change_type'},
            {name:'amount',title:'金额',type:'input'},
            {name:'is_sync',title:'是否已下发',type:'book',code:'yesOrNo'},
            {name:'park_id',type:'select',url:'${path.basePath}/ms/x/parking/findListData',valuefield:'id',textfield:'parkName',title:'停车场名称'},
            {name:'remark',title:'备注',type:'text',placeholder:'多行文本'},
            {name:'is_add',title:'是否是充值金额',type:'book',code:'yesOrNo'},
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
