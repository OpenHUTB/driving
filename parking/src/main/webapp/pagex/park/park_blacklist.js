var modelConfig= {title:'黑名单',pkey:'id',type:'snow',orderBy:'update_time Desc',
    namespace:"park_blacklist",table:'t_park_blacklist',trans:true,db:"park",dp:JSON.stringify({park_id:'parkIds'}),isMultiTenant:true};
var listPage={
    listFieldSett:function(){
	  return [
		  {name:'plate_number',title:'车牌号',width:'20%',align:'center'},
          {name:'park_id',title:'停车场名称',width:'20%',trans:'pagex',key:'parking',showField:'transMap.parkName',align:'center'},
          {name:'lock_status',title:'状态',formart:'formatRowColor',width:'10%',align:'center',trans:'book',key:'lock_status',showField:'transMap.lock_statusName'},
          {name:'create_user',title:'创建人',width:'8%',align:'center',trans:'user',showField:'transMap.create_userUserName'},
          {name:'create_time',title:'创建时间',width:'10%',align:'center'},
          {name:'update_user',title:'更新人',width:'8%',align:'center',trans:'user',showField:'transMap.update_userUserName'},
          {name:'update_time',title:'更新时间',width:'10%',align:'center'},
          {name:'is_sync',title:'是否已下发',width:'7%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.is_syncName'},
  ]},
  isColumnButton:function(){
	  return  false;
  },
  filters:function(){
      return [
          {name:'park_id',type:'select',url:'${path.basePath}/ms/x/parking/findListData',
              valuefield:'id',textfield:'parkName',title:'停车场',showAll:true},
          {name:'plate_number',type:'input',title:'车牌号',filterType:'like'},
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
             {name:'plate_number',title:'车牌号',required:true,type:'input',dataType:"plate_number|plate_number_new"},
             {name:'lock_status',title:'状态',required:true,type:'book',code:'lock_status'},
             {name:'description',title:'备注',type:'text'},
             {name:'is_sync',title:'是否已经下发',type:'hide'},
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
       getConflictMsg:function(){
           return '此车牌号在此停车场已经是黑名单啦';
       },
		saveSucess:function(){
	    },
		saveError:function(){
		    
	    },
	  }		
   }
}
