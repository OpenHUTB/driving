var modelConfig= {title:'LED灯显示',pkey:'id',type:'snow',
    orderBy:'update_time Desc',namespace:"parking_port_led",table:'t_park_parking_port_led',trans:true,isMultiTenant:true,db:"park",dp:JSON.stringify({park_id:'parkIds'})};
var listPage={
    listFieldSett:function(){
	  return [
	    {name:'park_id',title:'停车场名称',width:'15%',trans:'pagex',key:'parking',showField:'transMap.parkName',align:'center'},
        {name:'port_id',title:'所在出入口',width:'15%',align:'center',trans:'pagex',key:'parking_port',showField:'transMap.portName'},
        {name:'last_recv_time',title:'LED最后接收数据时间',width:'15%',align:'center'},
        {name:'description',title:'描述',width:'34%',align:'center'},
        {name:'is_disable',title:'是否启用',width:'10%',formart:'formatRowColor',align:'center',trans:'book',key:'is_disable',showField:'transMap.is_disableName'},
        {name:'is_sync',title:'是否已下发',width:'10%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.is_syncName'},
    ]},
    isColumnButton:function(){
	  return  true;
  },
  filters:function(){
      return [
        {name: 'park_id', type: 'select', url: '${path.basePath}/ms/x/parking/findListData',valuefield: 'id', textfield: 'parkName', title: '停车场',showAll:true},
        {name:'is_disable',title:'是否启用',type:'book',code:'is_disable',showAll:true}
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
            {name:'description',title:'描述',type:'text'},
            {name:'is_disable',title:'是否启用',type:'book',code:'is_disable',required:true},
            {name:'is_sync',title:'是否下发',type:'hide'},

            {name:'text_1',title:'LED文字1',type:'text'},
            {name:'font_color_1',title:'字体颜色1',type:'book',code:'font_color',required:true},
            {name:'speed_1',title:'速度1',type:'book',code:'speed',required:true},
            {name:'show_type_1',title:'显示类型1',type:'book',code:'show_type',required:true},
            {name:'stunt_in_1',title:'入场动画1',type:'book',code:'stunt',required:true},
            {name:'stunt_out_1',title:'出场动画1',type:'book',code:'stunt',required:true},

            {name:'text_2',title:'LED文字2',type:'text'},
            {name:'font_color_2',title:'字体颜色2',type:'book',code:'font_color',required:true},
            {name:'speed_2',title:'速度2',type:'book',code:'speed',required:true},
            {name:'show_type_2',title:'显示类型2',type:'book',code:'show_type',required:true},
            {name:'stunt_in_2',title:'入场动画2',type:'book',code:'stunt',required:true},
            {name:'stunt_out_2',title:'出场动画2',type:'book',code:'stunt',required:true},

            {name:'text_3',title:'LED文字3',type:'text'},
            {name:'font_color_3',title:'字体颜色3',type:'book',code:'font_color',required:true},
            {name:'speed_3',title:'速度3',type:'book',code:'speed',required:true},
            {name:'show_type_3',title:'显示类型3',type:'book',code:'show_type',required:true},
            {name:'stunt_in_3',title:'入场动画3',type:'book',code:'stunt',required:true},
            {name:'stunt_out_3',title:'出场动画3',type:'book',code:'stunt',required:true},

            {name:'text_4',title:'LED文字4',type:'text'},
            {name:'font_color_4',title:'字体颜色4',type:'book',code:'font_color',required:true},
            {name:'speed_4',title:'速度4',type:'book',code:'speed',required:true},
            {name:'show_type_4',title:'显示类型4',type:'book',code:'show_type',required:true},
            {name:'stunt_in_4',title:'入场动画4',type:'book',code:'stunt',required:true},
            {name:'stunt_out_4',title:'出场动画4',type:'book',code:'stunt',required:true},
		 ];
	},
    otherFunctions:function(){
      return {
	     ready:function(){
	        if('${param.isAdd}' == 'true'){
	            $('#isDisable').combobox('select','0');
	            $('#fontColor1').combobox('select','0');
	            $('#fontColor2').combobox('select','1');
	            $('#fontColor3').combobox('select','1');
	            $('#fontColor4').combobox('select','2');
                $('#speed1').combobox('select','0')
                $('#speed2').combobox('select','0')
                $('#speed3').combobox('select','0')
                $('#speed4').combobox('select','0')
                $('#showType1').combobox('select','0');
                $('#showType2').combobox('select','0');
                $('#showType3').combobox('select','0');
                $('#showType4').combobox('select','1');
                $('#stuntIn1').combobox('select','0');
                $('#stuntIn2').combobox('select','0');
                $('#stuntIn3').combobox('select','0');
                $('#stuntIn4').combobox('select','1');
                $('#stuntOut1').combobox('select','0');
                $('#stuntOut2').combobox('select','0');
                $('#stuntOut3').combobox('select','0');
                $('#stuntOut4').combobox('select','1');
	        }
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
	    reloadPort: function (record) {
            $('#portId').combobox('clear');
            $('#portId').combobox('reload', '${path.basePath}/ms/x/parking_port/findListData?parkId=' + record.id);
        }
	  }		
   }
}
