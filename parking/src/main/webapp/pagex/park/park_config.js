var modelConfig= {title:'车厂特定配置',pkey:'id',type:'snow',orderBy:'update_time Desc',
    namespace:"park_config",table:'t_park_config',trans:true,db:"park",dp:JSON.stringify({park_id:'parkIds'}),isMultiTenant:true};

var listPage={
    listFieldSett:function(){
	  return [
		  {name:'config_name',title:'配置名称',width:'10%',align:'center'},
          {name:'config_code',title:'配置编码',width:'10%',align:'center'},
          {name:'config_value',title:'配置值',width:'10%',align:'center'},
          {name:'park_id',title:'停车场名称',width:'10%',trans:'pagex',key:'parking',showField:'transMap.parkName',align:'center'},
          {name:'is_disable',title:'是否禁用',width:'10%',formart:'formatRowColor',align:'center',trans:'book',key:'is_disable',showField:'transMap.is_disableName'},
          {name:'is_sync',title:'是否已下发',width:'10%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.is_syncName'},
          {name:'create_user',title:'创建人',width:'9%',align:'center',trans:'user',showField:'transMap.create_userUserName'},
          {name:'create_time',title:'创建时间',width:'10%',align:'center'},
          {name:'update_user',title:'更新人',width:'9%',align:'center',trans:'user',showField:'transMap.create_userUserName'},
          {name:'update_time',title:'更新时间',width:'10%',align:'center'},
  ]},
  isColumnButton:function(){
	  return  false;
  },
  filters:function(){
      return [
          {name:'park_id',type:'select',url:'${path.basePath}/ms/x/parking/findListData',
              valuefield:'id',textfield:'parkName',title:'停车场',showAll:true},
          {name:'config_name',type:'input',title:'配置名称',filterType:'like'},
          {name:'config_code',type:'input',title:'配置编码',filterType:'like'},
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
                 valuefield:'id',textfield:'parkName',title:'停车场',required:true},
             {name:'config_name',title:'配置名称',required:true,type:'input'},
             {name:'config_code',title:'配置编码',required:true,type:'input'},
             {name:'config_value',title:'配置值',required:true,type:'input'},
             {name:'is_disable',title:'是否禁用',type:'switch',dft:false},
             {name:'description',title:'备注',type:'text'},
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
