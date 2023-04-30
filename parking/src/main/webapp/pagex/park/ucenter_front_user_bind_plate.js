var modelConfig= {title:'用户绑定的车牌号',pkey:'id',type:'snow',
    orderBy:'update_time Desc',
    namespace:"ucenter_front_user_bind_plate",table:'t_ucenter_front_user_bind_plate',trans:true,extendsParam:'front_user_id=${param.front_user_id}'};
var listPage={
    listFieldSett:function(){
	  return [
        {name:'plate_number',title:'车牌号',width:'99%',align:'center'},
    ]},
    isColumnButton:function(){
	  return  true;
  },
  filters:function(){
      return [
            {name:'front_user_id',title:'前段用户id',type:'input',filterType:'=',hidden:true},
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
