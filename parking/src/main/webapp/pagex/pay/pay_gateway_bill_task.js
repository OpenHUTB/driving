var modelConfig= {title:'网络支付对账任务',pkey:'id',type:'snow',
    orderBy:'bill_task_date Desc',namespace:"pay_gateway_bill_task",table:'t_pay_gateway_bill_task',trans:true,isMultiTenant:true,
    exjs: '${path.basePath}/js/dayjs.min.js'};
var listPage={
    listFieldSett:function(){
	  return [
        {name:'mch_name',title:'商户名称',width:'15%',align:'center'},
        {name:'bill_task_date',title:'对账任务日期',width:'10%',align:'center'},
        {name:'status',title:'状态',width:'10%',align:'center',trans:'book',key:'bill_status',showField:'transMap.statusName'},
        {name:'inconsistent_amont_nums',title:'金额不一致',width:'10%',align:'center'},
        {name:'swiftpass_miss_nums',title:'威富通丢单数量',width:'10%',align:'center'},
        {name:'park_miss_nums',title:'停车场丢单数量',width:'10%',align:'center'},
        {name:'square_num',title:'清算订单总数',width:'10%',align:'center'},
        {name:'square_amont',title:'清算总金额',width:'10%',align:'center'},
        {name:'alipay_square_amont',title:'支付宝清算金额',width:'10%',align:'center'},
        {name:'alipay_square_num',title:'支付宝清算订单数',width:'10%',align:'center'},
        {name:'weixin_square_amont',title:'微信清算金额',width:'10%',align:'center'},
        {name:'weixin_square_num',title:'微信清算订单数',width:'10%',align:'center'},
        {name:'error_info',title:'错误信息',width:'14%',align:'center'},
        {name:'file_id',title:'文件',align:'center',hidden:true},
       {name:'mch_id',title:'商户id',align:'center',hidden:true},
    ]},
    isColumnButton:function(){
	  return  true;
  },
  filters:function(){
      return [
        {name:'mch_name',title:'商户名称',type:'input',filterType:'like'},
        {name: 'bill_task_date',title:'对账任务日期',type:'date'},
        {name:'status',title:'状态',type:'book',code:'bill_status'},
	 ];
  },
  buttons:function(){
      return [
        {title:'重新对账',fun:'reconciliation',permissionsCode:'pay_gateway_bill_task:billReconciliation',isRow:true},
        {title:'查看差异账',fun:'differenceBill',permissionsCode:'pay_gateway_bill_log:update',isRow:true},
        {title:'下载对账单',fun:'downBill',permissionsCode:'pay_gateway_bill_log:see',isRow:true},
        {title:'手动对账',fun:'handBill',permissionsCode:'pay_gateway_bill_task:billReconciliation'},
      ];
  },
  disableButtons:function(){
	    return ["update","add"];
  },
  otherFunctions:function(){
      return {
        reconciliation:function(record){
            $.get({url:'${path.basePath}ms/pay_gateway_bill_task/billReconciliation?mch_id='+record.mchId+'&bill_task_date='+record.billTaskDate,success:function(res){
                if(res.code == 200){
                    Ealert("对账任务正在后台执行，请稍后查看对账结果");
                }else{
                    EalertE("系统异常,请联系管理员!");
                }
            },dataType:'json'});
        },
        differenceBill:function(record){
            var _openFrameMsg = {url:'${path.basePath}/ms/pagex/pay_gateway_bill_log_list.jsp?task_id=' + record.id,title:record.mchName+'的差异账记录'};
            top.postMessage(_openFrameMsg, '*');
        },
        downBill:function(_row){
            window.location.href = '${path.fhs_file_basePath}/downLoad/file?fileId='
                + _row.fileId+'&fileName='+_row.mchName + '.csv';
        },
        handBill:function(){
            openDialog('${path.basePath}/b/page-ms-pay/handBill',
                '手动对账');
        }
	  }
  }
};
var add={
	formFields:function(){
	     return [
            {name:'mch_name',title:'商户名称',type:'input',required:true},
            {name:'bill_task_date',title:'对账任务日期',type:'date',required:true},
            {name:'status',title:'状态',type:'book',code:'bill_status',required:true},
            {name:'inconsistent_amont_nums',title:'金额不一致',type:'input'},
            {name:'swiftpass_miss_nums',title:'威富通丢单数量',type:'input'},
            {name:'park_miss_nums',title:'停车场丢单数量',type:'input'},
            {name:'square_num',title:'清算订单总数',type:'input'},
            {name:'square_amont',title:'清算总金额',type:'input'},
            {name:'error_info',title:'错误信息',type:'text'},
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
