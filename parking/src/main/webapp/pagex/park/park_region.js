var modelConfig= {title:'停车场区域',pkey:'id',type:'snow',
    orderBy:'update_time Desc',
    namespace:"park_region",table:'t_park_region',trans:true, db:"park",dp:JSON.stringify({park_id:'parkIds'}),
    extendsParam:'park_id=${param.park_id}',joinColumns:JSON.stringify({region_name:'regionName'})};
var listPage={
    listFieldSett:function(){
	  return [
        {name:'region_name',title:'区域名称',width:'15%',align:'center'},
        {name:'space_num',title:'车位数',width:'15%',align:'center'},
        {name:'is_only_monthly',title:'是否仅月租',width:'15%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.is_only_monthlyName'},
        {name:'is_sync',title:'是否已下发',width:'14%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.is_syncName'},
        {name:'create_user',title:'创建人',width:'15%',align:'center',trans:'sysUser',showField:'transMap.create_userUserName'},
        {name:'create_time',title:'创建时间',width:'25%',align:'center'},
    ]},
    isColumnButton:function(){
	  return  true;
  },
  filters:function(){
      return [
        {name:'region_name',title:'区域名称',type:'input',filterType:'like'},
	 ];
  },
  buttons:function(){
      return [
          {title:'停车位',fun:'parkingRegionLot',permissionsCode:'park_region:see',isRow:true},
      ];
  },
  disableButtons:function(){
	    return ["delete"];
  },
  otherFunctions:function(){
      return {
          parkingRegionLot:function(row){
              var parkId = "${param.park_id}";
              var _openFrameMsg = {url:'${path.basePath}/ms/pagex/park_region_lot_list.jsp?park_id=' + parkId + '&region_id='+row.id,title:row.regionName + '的停车位'}
              top.postMessage(_openFrameMsg, '*');
          },
	  }
  }
};
var add={
	formFields:function(){
	     return [
	        {name:'park_id',title:'停车场id',type:'hide'},
            {name:'region_name',title:'区域名称',type:'input',required:true},
            {name:'space_num',title:'车位数',type:'input',dataType:'n1-3',required:true},
            {name:'is_only_monthly',title:'是否仅月租',type:'book',code:'yesOrNo',required:true},
            {name:'is_sync',title:'是否同步',type:'hide'},
		 ];
	},
    otherFunctions:function(){
      return {
	    ready:function(){
	        var parkId = "${param.park_id}";
	        $('#parkId').val(parkId);
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
