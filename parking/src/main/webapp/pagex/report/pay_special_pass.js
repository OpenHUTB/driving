var modelConfig= {title:'特殊放行纪录',pkey:'id',type:'snow',db:"park",dp:JSON.stringify({park_id:'parkIds'}),dataGridUrl:'${path.basePath}/ms/pay_special_pass/findPager',
    orderBy:'update_time Desc',namespace:"pay_special_pass",table:'t_pay_special_pass',trans:true,exjs:'${path.staticPath}/js/My97DatePicker/WdatePicker.js',isMultiTenant:true};
var listPage={
    listFieldSett:function(){
	  return [
        {name:'parkName',title:'停车场名称',width:'10%',align:'center',trans:'simple',target:'com.xhb.park.bean.ParkParking',field:'parkName',showField:'transMap.parkName',sortable:false},
        {name:'portName',title:'出口名称',width:'10%',align:'center',sortable:false},
        {name:'userName',title:'收费员',width:'8%',align:'center',trans:'simple',target:'com.xhb.park.bean.UcenterTollCollector',field:'name',alias:'user',showField:'transMap.userName',sortable:false},
        {name:'plate_number',title:'车牌号',width:'10%',align:'center'},
        {name:'park_time',title:'停车时长(分钟)',width:'8%',align:'center'},
        {name:"totalAmount",title:'损失金额',width:'8%',align:'center',trans:'simple',target:'com.xhb.pay.bean.PayTempOrderHistory',field:'totalAmount',showField:'transMap.totalAmount',sortable:false},
        {name:'describ',title:'放行原因',width:'25%',align:'center',trans:'simple',target:'com.xhb.park.bean.ParkSpecialPassType',field:'describ',showField:'transMap.describ',sortable:false},
        {name:'create_time',title:'放行时间',width:'10%',align:'center'},
        {name:'is_sync',title:'是否已经同步',width:'10%',align:'center',trans:'book',key:'is_sync',showField:'transMap.is_syncName'},
    ]},
    isColumnButton:function(){
	  return  true;
  },
  filters:function(){
      return [
        {name:'park_id',type:'select',url:'${path.basePath}/ms/x/parking/findListData',valuefield:'id',textfield:'parkName',title:'停车场',showAll:true},
        {name:'is_sync',title:'是否已经同步',type:'book',code:'is_sync'},
        {name:'plate_number',title:'车牌号',type:'input',filterType:'like'},
        {name:'create_time',title:'放行时间',type:'dateBT',isBT:true}
	 ];
  },
  buttons:function(){
      return [
        {title:'导出',fun:'exportPassExcel',permissionsCode:'pay_special_pass:see',isRow:false,},
      ];
  },
  disableButtons:function(){
	    return ["add","update","export"];
  },
  otherFunctions:function(){
      return {
        exportPassExcel:function(){
            var _fieldArray = getExcelFields();
            console.log(_fieldArray);
            $.ajax({
                url: "${path.basePath}/ms/pay_special_pass/setExportField",
                type: "post",
                contentType: "application/json;charset=utf-8",
                dataType: "json",
                data: json2str(_fieldArray),
                success: function (result) {
                    window.location.href = "${path.basePath}/ms/pay_special_pass/exportPassExcel?excelName=" + encodeURIComponent('特殊放行记录');
                }
            });
        }
	  }
  }
};

var add={
	formFields:function(){
	     return [
	        {name:'park_id',type:'select',url:'${path.basePath}/ms/x/parking/findListData',valuefield:'id',textfield:'parkName',title:'停车场',required:true},
            {name:'out_port_id',type:'select',url:'${path.basePath}/ms/x/parking_port/findListData',valuefield:'id',textfield:'portName',title:'出口名称',required:true},
            {name:'collector_id',title:'收费员',type:'select',url:'${path.basePath}/ms/x/ucenter_toll_collector/findListData',valuefield:'collectorId',textfield:'name',required:true},
            {name:'plate_number',title:'车牌号',type:'input',required:true},
            {name:'park_time',title:'停车时长(分钟数)',type:'input'},
            {name:"loss_amount",title:'损失金额',type:'input'},
            {name:'is_sync',title:'是否已经同步',type:'book',code:'is_sync',required:true},
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
