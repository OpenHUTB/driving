var modelConfig= {title:'手动抬杆记录',pkey:'id',type:'snow',db:"park",dp:JSON.stringify({park_id:'parkIds'}),exjs:'${path.staticPath}/js/My97DatePicker/WdatePicker.js',
    orderBy:'create_time Desc',namespace:"pay_hand_lift_rod",table:'t_pay_hand_lift_rod',trans:true,extendsParam:'collector_id=${param.collector_id}',isMultiTenant:true};
var listPage={
    listFieldSett:function(){
	  return [
        {name:'park_id',title:'停车场名称',width:'10%',align:'center',trans:'simple',target:'com.xhb.park.bean.ParkParking',field:'parkName', showField:'transMap.parkName'},
        {name: 'collector_id', title: '收费员', width: '10%',align: 'center',trans:'simple',target:'com.xhb.park.bean.UcenterTollCollector',field:'name',alias:'user',showField:'transMap.userName'},
        {name: 'port_id', title:'出入口名称', width:'10%',align:'center',trans:'simple',target:'com.xhb.park.bean.ParkParkingPort',field:'portName', showField:'transMap.portName' },
        {name:'plate_number',title:'车牌号',width:'10%',align:'center'},
        {name:'cash_pay',title:'收费金额',width:'10%',align:'center'},
        {name:'remark',title:'手动抬杆原因',width:'25%',align:'center'},
        {name:'create_time',title:'抬杆时间',width:'14%',align:'center'},
        {name:'is_sync',title:'是否已下发',width:'10%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.is_syncName'},
    ]},
    isColumnButton:function(){
	  return  true;
  },
  filters:function(){
      return [
         {name:'park_id',type:'select',url:'${path.basePath}/ms/x/parking/findListData',valuefield:'id',textfield:'parkName',title:'停车场',onSelect:'reloadPortF'},
         {name:'port_id',type:'select',url: '${path.basePath}/ms/x/parking_port/findListData',valuefield:'id',textfield:'portName',title:'出入口'},
         {name:'create_time',type:'dateBT',title:'抬杆时间',isBT:true,formart:'yyyy-MM-dd',filterType: 'like'},
         {name:'update_time',type:'date',title:'',formart:'yyyy-MM-dd',filterType:'like',hidden:true}
	 ];
  },
  buttons:function(){
      return [];
  },
  disableButtons:function(){
	    return ["add","update"];
  },
  otherFunctions:function(){
      return {
        onListPageReady: function () {
            if('${param.update_time}' != ''){
                $('#updateTimeF').val('${param.update_time}');
                reload();
                $('#updateTimeF').val('');
            }
        },
        reloadPortF:function(record){
            $('#portIdF').combobox('clear');
            $('#portIdF').combobox('reload', '${path.basePath}/ms/x/parking_port/findListData?parkId=' + record.id);
        }
	  }
  }
};
var add={
	formFields:function(){
	     return [
            {name:'park_id',type:'select',url:'${path.basePath}/ms/x/parking/findListData',valuefield:'id',textfield:'parkName',title:'停车场',required:true},
            {name:'port_id',type:'select',url:'${path.basePath}/ms/x/parking_port/findListData',valuefield:'id',textfield:'portName',title:'出口名称',required:true},
             {name:'plate_number',type:'input',title:'车牌号'},
             {name:'collector_id',title:'收费员',type:'select',url:'${path.basePath}/ms/x/ucenter_toll_collector/findListData',valuefield:'collectorId',textfield:'name',required:true},
            {name:'cash_pay',title:'收费金额',type:'input'},
             {name:'img_id',title:'图片',type:'up',placeholder:'请上传图片'},
            {name:'remark',title:'备注',type:'text'},
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
