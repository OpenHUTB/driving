var modelConfig= {title:'车场视频配置管理',pkey:'id',type:'snow',
    orderBy:'update_time Desc',db:"park",dp:JSON.stringify({park_id:'parkIds'}),
    namespace:"park_vedio_conf",table:'t_park_vedio_conf',trans:true,isMultiTenant:true};
var listPage={
    listFieldSett:function(){
	  return [
        {name:'park_id',title:'停车场名称',width:'15%',trans:'pagex',key:'parking',showField:'transMap.parkName',align:'center'},
        {name:'port_id',title:'出入口名称',width:'15%',align:'center',trans:'pagex',key:'parking_port',showField:'transMap.portName'},
        {name:'v_type',title:'流类型',width:'15%',align:'center',trans:'book',key:'v_type',showField:'transMap.v_typeName'},
        {name:'is_sync',title:'是否已下发',width:'15%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.is_syncName'},
        {name:'remark',title:'备注',width:'39%',align:'center'},
    ]},
    isColumnButton:function(){
	  return  true;
  },
  filters:function(){
      return [
        {name:'park_id',type:'select',url:'${path.basePath}/ms/x/parking/findListData',valuefield:'id',textfield:'parkName',title:'停车场',showAll:true},
        {name:'port_id',type:'select',url: '${path.basePath}/ms/x/parking_port/findListData',valuefield:'id',textfield:'portName',title:'出入口',showAll:true}
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
	  }
  }
};
var add={
	formFields:function(){
	     return [
	        {name:'park_id',type:'select',url:'${path.basePath}/ms/x/parking/findListData',valuefield:'id',textfield:'parkName',title:'停车场',onSelect:'reloadPort',required:true},
            {name:'port_id',type:'select',url:'${path.basePath}/ms/x/parking_port/findListData',valuefield:'id',textfield:'portName',title:'出入口',required:true},
            {name:'v_type',title:'流类型',type:'book',code:'v_type',required:true},
            {name:'is_disable',title:'是否禁用',type:'hide'},
            {name:'is_sync',type:'hide'},
            {name:'token',type:'hide'},
            {name:'remark',title:'备注',type:'text',placeholder:'多行文本'},
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
            $('#isDisable').val(1);
            if('${param.isAdd}'=='true')
            {
                $('#token').val(uuid());
            }
	    },
		saveSucess:function(){
	    },
		saveError:function(){

	    },
	    reloadPort: function (record) {
            $('#portId').combobox('clear');
            $('#portId').combobox('reload', '${path.basePath}/ms/x/parking_port/findListData?parkId=' + record.id);
        }
	  }
   }
}
