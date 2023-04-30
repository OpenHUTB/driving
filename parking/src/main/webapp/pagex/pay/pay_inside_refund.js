var modelConfig= {title:'',pkey:'id',type:'snow',orderBy:'create_time Desc',
    namespace:"pay_inside_refund",table:'t_pay_inside_refund',trans:true,saveUrl:'${path.basePath}/ms/pay_inside_refund/refundInfoAdd'
    , exjs: '${path.staticPath}/js/My97DatePicker/WdatePicker.js'
    ,db:"park",dp:JSON.stringify({park_id:'parkIds'}),extendsParam:'inside_id=${param.inside_id}'};
var listPage={
    listFieldSett:function(){
	  return [
        {name: 'is_contract', title: '是否是月租户',width:'8%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.is_contractName'},
        {name:'refund_amont',title:'退款金额',width:'8%',align:'center'},
        {name:'service_amount',title:'手续费金额',width:'8%',align:'center'},
        {name:'deduct_give_amount',title:'扣除赠送金额',width:'8%',align:'center'},
        {name:'refund_cus_name',title:'接收退款的客户名称',width:'8%',align:'center'},
        {name:'monthly_end_date',title:'月租提前结束时间',width:'10%',align:'center'},
        {name:'remark',title:'备注',width:'33%',align:'center'},
        {name:'create_user',title:'操作人',width:'8%',align:'center',trans:'user',showField:'transMap.create_userUserName'},
        {name:'is_sync',title:'是否已下发',width:'8%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.is_syncName'},
    ]},
    isColumnButton:function(){
	  return  true;
  },
  filters:function(){
      return [
        {name:'park_id',title:'停车场', type:'select',url:'${path.basePath}/ms/x/parking/findListData',valuefield:'id',textfield:'parkName',showAll:true},
        {name:'is_contract',title:'是否是月租户',type:'book',code:'yesOrNo'},
	 ];
  },
  buttons:function(){
      return [];
  },
  disableButtons:function(){
	    return ["add","update","delete"];
  },
  otherFunctions:function(){
      return {
          setExcelName:function () {
              return "退款记录列表";
          }
	  }
  }
};
var add={
	formFields:function(){
	     return [
	        {name:'is_contract',title:'是否是月租户',type:'hide'},
	        {name:'park_id',type:'hide',title:'停车场id',required:true},
            {name:'inside_id',type:'hide',title:'内部用户id',required:true},
            {name:'contract_id',type:'hide',title:'月租户充值记录id',required:true},
	        {type:'divStart',id:'addShowDiv',style:'display:none;'},
            {class:'owner_name',type:'input',title:'内部用户'},
            {class: 'owner_mobile',type: 'input',title: '车主电话'},
            {class:'room_num',type:'input',title:'房间号'},
            {class:'lease_type',type:'input',title:'月租户类型'},
            {class:'monthly_type_name',type:'input',title:'租赁类型'},
            {type:'divEnd'},

            {type:'divStart',id:'monthRefundShowDiv',style:'display:none;'},
            {class: 'end_date', title: '月租到期日', type: 'input'},
            {type:'divEnd'},
            {type:'divStart',id:'monthRefundDiv',style:'display:none;'},
            {name:'monthly_end_date',title:'月租提前结束日',type:'date',formart:'yyyy-MM-dd',onpicked:'dateCheck()'},
            {type:'divEnd'},

            {type:'divStart',id:'rechargeRefundShowDiv',style:'display:none;'},
            {class:'amount',title:'最后一次充值金额',type:'input'},
            {class:'give_amount',title:'最后一次充值赠送金额',type:'input'},
            {class: 'balance', title: '账户余额',type: 'input'},
            {type:'divEnd'},

            {type:'divStart',id:'rechargeRefundDiv',style:'display:none;'},
            {name:'deduct_give_amount',title:'扣除赠送金额',type:'input',dataType: 'n1-6|double2'},
            {type:'divEnd'},

            {name:'lot_num',title:'车位数',type:'input',dataType:'n1-2',required:true,onchange:'lotNumCheck()'},
            {name:'refund_amont',title:'退款金额',type:'input',dataType: 'n1-6|double2',required:true},
            {name:'service_amount',title:'服务费',type:'input',dataType: 'n1-6|double2',required:true},
            {name:'refund_cus_name',title:'接收退款人',type:'input'},
            {name:'remark',title:'备注',type:'text'},
		 ];
	},
    otherFunctions:function(){
      return {
	     ready:function(){
	        if('${param.isAdd}' == 'true'){
	            $('#parkId').val('${param.park_id}');
                $('#insideId').val('${param.inside_id}');
                $('#lotNum').val('${param.lot_num}');
                $('.owner_name').val('${param.owner_name}');
                $('.owner_mobile').val('${param.owner_mobile}');
                $('.room_num').val('${param.room_num}');
                $('.lease_type').val('${param.lease_type}');
                $('.monthly_type_name').val('${param.monthly_type_name}');
                $('#addShowDiv').show();
                $('#serviceAmount').val(0);
                renderView('addShowDiv');
                if(['0','1','2'].indexOf('${param.monthly_type}') > -1){
                    //月租
                    $('#contractId').val('${param.contract_id}');
                    $('.end_date').val('${param.end_date}');
                    $('#monthRefundDiv').show();
                    $('#monthRefundShowDiv').show();
                    renderView("monthRefundShowDiv");
                }else{
                    //储户时段租
                     $('.amount').val('${param.amount}');
                     $('.give_amount').val('${param.give_amount}');
                     $('.balance').val('${param.balance}');
                     $('#rechargeRefundDiv').show();
                     $('#rechargeRefundShowDiv').show();
                     renderView("rechargeRefundShowDiv");
                }
	        }else{
	            $('#addShowDiv').hide();
	        }
	    },
	    loadSuccess:function(info){
	        if(info.isContract == 1){
                $('#monthRefundDiv').show();
	        }else{
	            $('#rechargeRefundDiv').show();
	        }
	    },
	    onSave:function(){
	    },
		saveSucess:function(){
	    },
		saveError:function(){

	    },
	    dateCheck:function(){
            if($('.end_date').val() <= $('#monthlyEndDate').val()){
                $('#monthlyEndDate').val("");
                EalertE("月租提前结束日不能小于月租到期日");
                return false;
            }
	    },
	    lotNumCheck:function(){
	        if($('#lotNum').val() > '${param.lot_num}'){
                $('#lotNum').val('${param.lot_num}');
                EalertE('您只拥有'+'${param.lot_num}'+'个车位哦');
                return false;
           }
	    }
	  }
   }
}
