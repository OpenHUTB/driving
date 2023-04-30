var modelConfig= {title:'月租收费规则',pkey:'id',type:'snow',orderBy:'update_time Desc',
    namespace:"park_monthly_rule",table:'t_park_monthly_rule',trans:true,db:"park",joinColumns:JSON.stringify({rule_name:'ruleName'}),
    dp:JSON.stringify({park_id:'parkIds'}),isMultiTenant:true};

var listPage={
    listFieldSett:function(){
	  return [
		  {name:'rule_name',title:'规则名称',width:'15%',align:'center'},
          {name:'park_id',title:'停车场名称',width:'15%',trans:'pagex',key:'parking',showField:'transMap.parkName',align:'center'},
          {name:'start_time',title:'开始时间',width:'10%',align:'center'},
          {name:'end_time',title:'结束时间',width:'10%',align:'center'},
          {name:'car_type',title:'车辆类型',width:'10%',align:'center',trans:'book',key:'car_type',showField:'transMap.car_typeName'},
          {name:'monthly_type',title:'租赁类型',width:'10%',align:'center',trans:'book',key:'monthly_type',showField:'transMap.monthly_typeName'},
          {name:'is_disable',title:'是否禁用',width:'10%',formart:'formatRowColor',align:'center',trans:'book',key:'is_disable',showField:'transMap.is_disableName'},
          {name:'is_sync',title:'是否已下发',width:'10%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.is_syncName'},
          {name:'lease_type_sett',title:'费用配置',hidden:true},
          {name:'create_user',title:'创建人',width:'9%',align:'center',trans:'sysUser',showField:'transMap.create_userUserName'},
          {name:'max_date',title:'最大包月时间',hidden:true},
          {name:'min_month',title:'最小租赁月数',hidden:true},
  ]},
  isColumnButton:function(){
	  return  false;
  },
  filters:function(){
      return [
          {name:'park_id',type:'select',url:'${path.basePath}/ms/x/parking/findListData',
              valuefield:'id',textfield:'parkName',title:'停车场',showAll:true},
          {name:'car_type',type:'book',code:'car_type',title:'车辆类型',showAll:true},
          {name:'is_disable',type:'book',code:'is_disable',title:'是否禁用',showAll:true},
          {name:'monthly_type',type:'book',code:'monthly_type',title:'租赁类型',showAll:true},
          {name:'rule_name',type:'input',title:'规则名称',filterType:'like'},

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
             {name:'park_id',type:'select',url:'${path.basePath}/ms/x/parking/findListData',
                 valuefield:'id',textfield:'parkName',title:'停车场',required:true,onSelect:'onParkingChange'},
             {name:'rule_name',title:'名称',required:true,type:'input'},
             {name:'car_type',title:'车辆类别',required:true,type:'book',code:'car_type'},
             {name:'monthly_type',title:'租赁类型',required:true,type:'book',code:'monthly_type',onSelect:'onTypeChange'},
             {type:'divStart',id:'dateDiv',style:'display:none;'},
             {name:'start_time',title:'白天开始时间',type:'time'},
             {name:'end_time',title:'白天结束时间',type:'time'},
             {type:'divEnd'},
             {type:'divStart',id:'timeRent',style:'display:none;'},
             {name:'time_hours',title:'时段小时数',type:'input',required:true},
             {name:'time_charge',title:'时段收费金额',type:'input',required:true},
             {type:'divEnd'},
             {type:'divStart',id:'propertyFeeDiv',style:'display:none;'},
             {name:'min_month',title:'最小租赁月数',type:'input',dataType:'n1-2'},
             {name:'min_date',title:'最小包月时间',type:'date'},
             {name:'max_date',title:'最大包月时间',type:'date'},
             {type:'divEnd'},
             {name:'is_ms_only',title:'是否仅后台显示此规则',type:'book',code:'yesOrNo'},
             {name:'is_disable',title:'是否禁用',type:'switch',dft:false},
             {name:'description',title:'备注',type:'text'},
             {name:'is_sync',title:'是否下发',type:'hide'},
             {name:'lease_type_sett',title:'不同租赁类型价格设置',type:'hide'},
		 ];
	},
    otherFunctions:function(){
      return {
	     ready:function(){
             if('${param.isAdd}'=='true')
             {
                $('#timeHours').val(0);
                $('#timeCharge').val(0);
                $('#propertyFee').val(0);
                $('#startTime').val('00:00');
                $('#endTime').val('23:59');
             }
	    },
	    loadSuccess:function(info){
	        if(info.monthlyType == 4){
	            $("#timeRent").show();
	        }
	        if(["0","1","2"].indexOf(info.monthlyType) > -1){
	            $("#propertyFeeDiv").show();
	        }
	        if(["1","2"].indexOf(info.monthlyType) > -1){
                $("#dateDiv").show();
            }
            renderLeaseTypeSett(info);
	    },
	    onSave:function(){
	        if($('#monthlyType').combobox('getValue') == "4"){
	            /*if(!$("#timeHours").val()){
                    EalertE("时段小时数不能为空");
                    return false;
                }
                if(!$("#timeCharge").val()){
                    EalertE("时段收费金额不能为空");
                    return false;
                }
                $('#propertyFee').val(0);*/
	        }
	        if($('#monthlyType').combobox('getValue') == "3"){
	            //$('#propertyFee').val(0);
	            $('#timeHours').val(0);
                $('#timeCharge').val(0);
	        }
	        if(['0','1','2'].indexOf($('#monthlyType').combobox('getValue')) > -1){
	            /*if(!$('#propertyFee').val()){
	                EalertE("物业费不能为空");
                    return false;
	            }*/
	            $('#timeHours').val(0);
                $('#timeCharge').val(0);
	        }
            updateLeaseTypeSett();
            $('#isSync').val(0);
	    },
		saveSucess:function(){
	    },
		saveError:function(){

	    },
	    onTypeChange:function(record){
	        $("#timeRent").hide();
	        $("#propertyFeeDiv").hide();
	        $('#dateDiv').hide();
	        if(record.wordbookCode == 4){
                $("#timeRent").show();
	        }
            if(["0","1","2"].indexOf(record.wordbookCode) > -1){
                addUpdateForm.ignore("#timeHours");
                addUpdateForm.ignore("#timeCharge");
                $("#propertyFeeDiv").show();
                 if(record.wordbookCode != '0'){
                    $('#dateDiv').show();
                 }
            }


	    }
	  }
   }
}
