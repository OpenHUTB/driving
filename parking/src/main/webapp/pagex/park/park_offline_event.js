var modelConfig= {title:'车厂状态记录',pkey:'id',type:'snow',orderBy:'create_time Desc',
    namespace:"park_offline_event",table:'t_park_offline_event',trans:true,db:"park",
    dp:JSON.stringify({park_id:'parkIds'})
};

var listPage={
    listFieldSett:function(){
	  return [
          {name:'park_id',title:'停车场名称',width:'30%',isJoin:true,namespace:'parking',showField:'transMap.parkName',align:'center'},
          {name:'drop_time',title:'掉线时间',width:'25%',align:'center'},
          {name:'recovery_time',title:'恢复时间',width:'24%',align:'center'},
          {name:'event_state',title:'状态',width:'20%',align:'center',trans:'book',key:'event_state',showField:'transMap.event_stateName'},
      ]},
  isColumnButton:function(){
	  return  false;
  },
  filters:function(){
      return [
          {name:'park_id',type:'select',url:'${path.basePath}/ms/x/parking/findListData',
              valuefield:'id',textfield:'parkName',title:'停车场',showAll:true},
	  ];
  }, 
  buttons:function(){
      return [
      ];
  },
  disableButtons:function(){
	    return ["view","add","update"];
  },
  otherFunctions:function(){
      return {}
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
