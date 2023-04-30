var modelConfig= {title:'月租户类型',pkey:'id',type:'snow',orderBy:'update_time Desc',
    namespace:"parking_lease_type",table:'t_park_lease_type',trans:true,db:"park",joinColumns:JSON.stringify({lease_name:'leaseName'}),
    dp:JSON.stringify({park_id:'parkIds'}),isMultiTenant:true};
var listPage={
    listFieldSett:function(){
	  return [
		  {name:'lease_name',title:'类型名称',width:'15%',align:'center'},
          {name:'park_id',title:'停车场名称',width:'15%',trans:'pagex',key:'parking',showField:'transMap.parkName',align:'center'},
          {name:'is_mp_default',title:'是否是公众号默认类型',width:'10%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.is_mp_defaultName'},
          {name:'is_disable',title:'是否禁用',width:'10%',formart:'formatRowColor',align:'center',trans:'book',key:'is_disable',showField:'transMap.is_disableName'},
          {name:'create_user',title:'创建人',width:'10%',align:'center',trans:'user',showField:'transMap.create_userUserName'},
          {name:'create_time',title:'创建时间',width:'15%',align:'center'},
          {name:'update_user',title:'更新人',width:'10%',align:'center',trans:'user',showField:'transMap.create_userUserName'},
          {name:'update_time',title:'更新时间',width:'15%',align:'center'},
          {name:'is_sync',title:'是否已下发',width:'9%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.is_syncName'},
  ]},
  isColumnButton:function(){
	  return  false;
  },
  filters:function(){
      return [
          {name:'park_id',type:'select',url:'${path.basePath}/ms/x/parking/findListData',
              valuefield:'id',textfield:'parkName',title:'停车场',showAll:true},
          {name:'lease_name',type:'input',title:'类型名称',filterType:'like'},
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
      return {}
  }
};

var add={
	formFields:function(){
	     return [
             {name:'park_id',type:'select',url:'${path.basePath}/ms/x/parking/findListData',
                 valuefield:'id',textfield:'parkName',title:'停车场',required:true,},
             {name:'lease_name',title:'名称',required:true,type:'input'},
             {name:'is_mp_default',title:'是否是公众号默认类型',type:'book',code:'yesOrNo'},
             {name:'is_disable',title:'是否禁用',type:'switch',dft:false},
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
