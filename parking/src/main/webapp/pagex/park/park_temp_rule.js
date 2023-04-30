var modelConfig= {title:'临时收费规则',pkey:'id',type:'snow',orderBy:'update_time Desc',
    namespace:"park_temp_rule",table:'t_park_temp_rule',trans:true,db:"park",dp:JSON.stringify({park_id:'parkIds'}),isMultiTenant:true};

var listPage={
    listFieldSett:function(){
	  return [
		  {name:'rule_name',title:'规则名称',width:'20%',align:'center'},
          {name:'park_id',title:'停车场名称',width:'20%',trans:'pagex',key:'parking',showField:'transMap.parkName',align:'center'},
          {name:'car_type',title:'车辆类型',width:'10%',align:'center',trans:'book',key:'car_type',showField:'transMap.car_typeName'},
          {name:'charge_type',title:'计费类型',width:'10%',align:'center',trans:'book',key:'temp_charge_type',showField:'transMap.charge_typeName'},
          {name:'is_disable',title:'是否禁用',width:'10%',formart:'formatRowColor',align:'center',trans:'book',key:'is_disable',showField:'transMap.is_disableName'},
          {name:'is_sync',title:'是否已下发',width:'14%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.is_syncName'},
          {name:'create_user',title:'创建人',width:'15%',align:'center',trans:'sysUser',showField:'transMap.create_userUserName'},
  ]},
  isColumnButton:function(){
	  return  false;
  },
  filters:function(){
      return [
          {name:'park_id',type:'select',url:'${path.basePath}/ms/x/parking/findListData',
              valuefield:'id',textfield:'parkName',title:'停车场',showAll:true},
          {name:'car_type',type:'book',code:'car_type',title:'车辆类型',showAll:true},
          {name:'charge_type',type:'book',code:'temp_charge_type',title:'计费类型',showAll:true},
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
                 valuefield:'id',textfield:'parkName',title:'停车场',required:true},
             {name:'rule_name',title:'名称',required:true,type:'input'},
             {name:'car_type',title:'车辆类别',required:true,type:'book',code:'car_type'},
             /*{name:'user_type',title:'用户类型',required:true,type:'book',code:'user_type'},*/
             {name:'charge_type',title:'计费类型',required:true,type:'book',code:'temp_charge_type',onSelect:'chargeTypeChange'},
             {name:'is_disable',title:'是否禁用',type:'switch',dft:false},
             {type:'divStart',id:'allDayChargeShowDiv',class:'hide changeDiv'},
                {name:'all_day_charge',title:'单价',type:'input',dataType:'double2'},
                {type:'br'},
             {type:'divEnd'},
             {type:'divStart',id:'dayNightShowDiv',class:'hide changeDiv'},
                {name:'day_charge',title:'白天单价',type:'input',dataType:'double2'},
                {name:'night_charge',title:'晚上单价',type:'input',dataType:'double2'},
                {name:'start_time',title:'白天开始时间',type:'time'},
                {name:'end_time',title:'白天结束时间',type:'time'},
             {type:'divEnd'},
             {type:'divStart',id:'dayRestChargeShowDiv',class:'hide changeDiv'},
                 {name:'day_rest_charge',title:'休息日单价',type:'input',dataType:'double2'},
                 {type:'br'},
             {type:'divEnd'},
             {type:'divStart',id:'restChargeShowDiv',class:'hide changeDiv'},
                {name:'rest_day_charge',title:'休息日白天单价',type:'input',dataType:'double2'},
                {name:'rest_night_charge',title:'休息日晚上单价',type:'input',dataType:'double2'},
             {type:'divEnd'},
             {type:'divStart',id:'restShowDiv',class:'hide changeDiv'},
                 {name:'week_data',title:'休息日',type:'book',code:'week_data',multiple:true},
             {type:'divEnd'},
             {type:'divStart',id:'timeRent',class:'hide changeDiv'},
                 {name:'time_hours',title:'时段小时数',type:'input',dataType: 'n1-2'},
                 {name:'time_charge',title:'时段收费金额',type:'input',dataType:'double2'},
             {type:'divEnd'},
             {name:'description',title:'备注',type:'text'},
             {name:'is_sync',title:'是否下发',type:'hide'},
		 ];
	},
    otherFunctions:function() {
        return {
            ready: function () {

            },
            loadSuccess: function (info) {
                chargeTypeChange({wordbookCode:info.chargeType});

            },
            onSave: function () {
                var _chanrgeTypeVal = $('#chargeType').combobox('getValue');
                $('#isSync').val(0);
                //整天规则
                if (_chanrgeTypeVal == '0' || _chanrgeTypeVal == '5') {
                    $('#dayCharge').val(0);
                    $('#nightCharge').val(0);
                    $('#dayRestCharge').val(0);
                    $('#restNightCharge').val(0);
                    $('#restDayCharge').val(0);
                    $('#weekData_select').combobox('clear');
                    $('#timeHours').val(0);
                    $('#timeCharge').val(0);
                    if(!$('#allDayCharge').val())
                    {
                        EalertE('单价不能为空');
                        return false;
                    }
                } else if (_chanrgeTypeVal == '1')//白天+晚上
                {
                    $('#allDayCharge').val(0);
                    $('#dayRestCharge').val(0);
                    $('#restNightCharge').val(0);
                    $('#restDayCharge').val(0);
                    $('#weekData_select').combobox('clear');
                    $('#timeHours').val(0);
                    $('#timeCharge').val(0);
                    if(!$('#dayCharge').val())
                    {
                        EalertE('白天单价不能为空');
                        return false;
                    }
                    if(!$('#nightCharge').val())
                    {
                        EalertE('晚上单价不能为空');
                        return false;
                    }
                } else if (_chanrgeTypeVal == '2')//普通整天+休息整天
                {
                    $('#dayCharge').val(0);
                    $('#nightCharge').val(0);
                    $('#restNightCharge').val(0);
                    $('#restDayCharge').val(0);
                    $('#timeHours').val(0);
                    $('#timeCharge').val(0);
                    if(!$('#weekData_select').combobox('getValue'))
                    {
                        EalertE('休息日为必选');
                        return false;
                    }
                    if(!$('#allDayCharge').val())
                    {
                        EalertE('普通日单价不能为空');
                        return false;
                    }
                    if(!$('#dayRestCharge').val())
                    {
                        EalertE('休息日单价不能为空');
                        return false;
                    }
                } else if (_chanrgeTypeVal == '3')//白天+晚上+休息日
                {
                    $('#allDayCharge').val(0);
                    $('#dayRestCharge').val(0);
                    $('#timeHours').val(0);
                    $('#timeCharge').val(0);
                    if(!$('#weekData_select').combobox('getValue'))
                    {
                        EalertE('休息日为必选');
                        return false;
                    }
                    if(!$('#dayCharge').val())
                    {
                        EalertE('白天单价不能为空');
                        return false;
                    }
                    if(!$('#nightCharge').val())
                    {
                        EalertE('晚上单价不能为空');
                        return false;
                    }
                    if(!$('#restDayCharge').val())
                    {
                        EalertE('休息日白天单价不能为空');
                        return false;
                    }
                    if(!$('#restNightCharge').val())
                    {
                        EalertE('休息日晚上单价不能为空');
                        return false;
                    }
                }else if(_chanrgeTypeVal == '4'){   //包时段规则
                    $('#dayCharge').val(0);
                    $('#allDayCharge').val(0);
                    $('#nightCharge').val(0);
                    $('#dayRestCharge').val(0);
                    $('#restNightCharge').val(0);
                    $('#restDayCharge').val(0);
                    $('#weekData_select').combobox('clear');
                    if(!$('#timeHours').val()){
                        EalertE('时段小时数不能为空');
                        return false;
                    }
                    if(!$('#timeCharge').val()){
                        EalertE('时段收费金额不能为空');
                        return false;
                    }
                }
            },
            saveSucess: function () {
            },
            getConflictMsg:function(){
                return '同一个停车场同一个车类型同一个计费类型只能有一条规则';
            },
            saveError: function () {

            },//切换收费类型的时候控制显示哪些div隐藏哪些div
            chargeTypeChange: function (rec) {
                var _chanrgeTypeVal = rec.wordbookCode;
                //整天规则
                if (_chanrgeTypeVal == '0' || _chanrgeTypeVal == '5') {
                    $('.changeDiv').hide();
                    $('#allDayChargeShowDiv').show();//单价显示
                } else if (_chanrgeTypeVal == '1')//白天+晚上
                {
                    $('.changeDiv').hide();
                    $('#dayNightShowDiv').show();// 白天晚上显示
                } else if (_chanrgeTypeVal == '2')//普通整天+休息整天
                {
                    $('.changeDiv').hide();
                    $('#allDayChargeShowDiv').show();//普通的显示
                    $('#restShowDiv').show();//休息日显示
                    $('#dayRestChargeShowDiv').show();//休息日单价
                } else if (_chanrgeTypeVal == '3')//白天+晚上+休息日
                {
                    $('.changeDiv').hide();
                    $('#dayNightShowDiv').show();// 白天晚上显示
                    $('#restShowDiv').show();//休息日显示
                    $('#restChargeShowDiv').show();//休息日单价
                } else if(_chanrgeTypeVal == '4'){  //包时段规则
                    $('.changeDiv').hide();
                    $('#timeRent').show();  //时段小时数和时段收费金额显示
                }
            }
        }
    }
}
