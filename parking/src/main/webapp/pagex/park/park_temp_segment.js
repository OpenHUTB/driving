var modelConfig= {title:'临时车收费时段',pkey:'id',type:'snow',orderBy:'update_time Desc',
    namespace:"park_temp_segment",table:'t_park_temp_segment',trans:true,db:"park",dp:JSON.stringify({park_id:'parkIds'}),isMultiTenant:true};

var listPage={
    listFieldSett:function(){
	  return [
		  {name:'segment_name',title:'时段名称',width:'14%',align:'center'},
          {name:'park_id',title:'停车场名称',width:'14%',trans:'pagex',key:'parking',showField:'transMap.parkName',align:'center'},
          {name:'day_start',title:'白天开始时间',width:'7%',align:'center'},
          {name:'day_end',title:'白天结束时间',width:'7%',align:'center'},
          {name:'night_start',title:'晚上开始时间',width:'7%',align:'center'},
          {name:'night_end',title:'晚上结束时间',width:'7%',align:'center'},
          {name:'create_user',title:'创建人',width:'8%',align:'center',trans:'user',showField:'transMap.create_userUserName'},
          {name:'create_time',title:'创建时间',width:'10%',align:'center'},
          {name:'update_user',title:'更新人',width:'8%',align:'center',trans:'user',showField:'transMap.create_userUserName'},
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
          {name:'segment_name',type:'input',title:'时段名称',filterType:'like'},
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
             {name:'segment_name',title:'时段名称',required:true,type:'input'},
             {name:'day_start',title:'白天开始时间',type:'time',required:true,},
             {name:'night_start',title:'晚上开始时间',type:'time',required:true,},
             {name:'description',title:'备注',type:'text'},
             {name:'day_end',title:'白天结束时间',type:'hide'},
             {name:'night_end',title:'晚上结束时间',type:'hide'},
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
	         // 晚上结束=日开始-1分钟
            if($('#dayStart').val()!='')
            {
                $('#nightEnd').val(minutesAdd($('#dayStart').val(),-1));
            }
            // 白天结束=晚上开始-1分钟
            if($('#nightStart').val()!='')
            {
                $('#dayEnd').val(minutesAdd($('#nightStart').val(),-1));
            }
	    },
		saveSucess:function(){
	    },
		saveError:function(){
		    
	    }, //分钟加减

	  }		
   }
}
