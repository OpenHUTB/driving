var modelConfig= {title:'网关支付订单',pkey:'order_no',type:'snow',
    orderBy:'order_no desc',db:"park",dp:JSON.stringify({park_id:'parkIds'}),
    dataGridUrl:'${path.basePath}/ms/pay_gateway_order/findPage?notCount=true',
    namespace:"pay_gateway_order",table:'t_pay_gateway_order',trans:true,isMultiTenant:true};

var listPage={
    listFieldSett:function(){
	  return [
	    {name:'orderNO',title:'订单号',width:'10%',align:'center'},
        {name:'park_id',title:'停车场名称',width:'10%',trans:'simple',target:'com.xhb.park.bean.ParkParking',field:'parkName',showField:'transMap.parkName',align:'center'},
        {name:'total_amount',title:'总金额',width:'10%',align:'center',formart:'amountFormat'},
        {name:'pay_type',title:'支付方式',width:'10%',align:'center',trans:'book',key:'pay_type',showField:'transMap.pay_typeName'},
        {name:'pay_status',title:'支付状态',width:'10%',align:'center',trans:'book',key:'pay_status',showField:'transMap.pay_statusName'},
        {name:'is_refund',title:'是否退款',width:'10%',align:'center',trans:'book',key:'is_refund',showField:'transMap.is_refundName'},
        /*{name:'is_reconciliation',title:'是否对过账',width:'10%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.is_reconciliationName'},
        {name:'reconciliation_date',title:'对账日期',width:'10%',align:'center'},
        {name:'settlement_amount',title:'结算金额',width:'10%',align:'center'},
        {name:'service_charge',title:'手续费金额',width:'10%',align:'center'},*/
        {name:'order_type',title:'订单类型',width:'10%',align:'center',trans:'book',key:'order_type',showField:'transMap.order_typeName'},
        {name:'pay_time',title:'支付时间',width:'10%',align:'center',formart:'timeFormat'},
    ]},
    isColumnButton:function(){
	  return  true;
  },
  filters:function(){
      return [
        {name: 'park_id', type: 'select', url: '${path.basePath}/ms/x/parking/findListData',valuefield: 'id', textfield: 'parkName', title: '停车场',showAll:true},
        {name:'pay_status',title:'支付状态',type:'book',code:'pay_status',showAll:true},
        {name:'is_refund',title:'是否退款',type:'book',code:'is_refund',showAll:true},
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
        timeFormat:function(_val,_row,_index){
            if(_val){
                var year = _val.substr(0,4);
                var month = _val.substr(4,2);
                var day = _val.substr(6,2)
                var hour = _val.substr(8,2);
                var minute = _val.substr(10,2);
                var second = _val.substr(12,2);
                return year+"-"+month+"-"+day+" "+hour+":"+minute+":"+second;
            }
            return '';
        },
        amountFormat:function(_val,_row,_index){
            if(_val){
                return (parseInt(_val)/100).toFixed(2);
            }
            return "";
        }
	  }
  }
};
var add={
	formFields:function(){
	     return [
            {name:'body',title:'订单详情',type:'text',required:true},
            {name:'park_id',type:'select',url:'${path.basePath}/ms/x/parking/findListData',valuefield:'id',textfield:'parkName',title:'停车场',required:true},
            {name:'total_amount',title:'总金额',type:'input',required:true},
            {name:'pay_type',title:'支付方式',type:'book',code:'pay_type',required:true},
            {name:'attach',title:'扩展参数',type:'input'},
            {name:'goods_tag',title:'商品标签',type:'input'},
            {name:'mch_id',title:'发起支付使用的商户id',type:'input',required:true},
            {name:'out_time',title:'超时时间',type:'input',required:true},
            {name:'pay_status',title:'支付状态',type:'book',code:'pay_status',required:true},
            {name:'is_refund',title:'是否退款',type:'book',code:'is_refund',required:true},
            {name:'swiftpass_mch_id',title:'威富通商户id',type:'input',required:true},
            {name:'open_id',title:'openid/支付宝 byuserid',type:'input'},
            /*{name:'is_reconciliation',title:'是否对过账',type:'book',code:'yesOrNo',required:true},
            {name:'reconciliation_date',title:'对账日期',type:'input'},
            {name:'settlement_amount',title:'结算金额',type:'input'},
            {name:'service_charge',title:'手续费金额',type:'input'},*/
            {name:'order_type',title:'订单类型',type:'book',code:'order_type',required:true},
            {name:'pay_order_no',title:'第三方收单机构订单号',type:'input'},
            {name:'pay_info',title:'支付信息',type:'input'},
            {name:'create_user',title:'创建人',type:'input'},
             {name:'create_time',title:'创建时间',type:'input'},
            {name:'update_user',title:'修改人',type:'input'},
            {name:'update_time',title:'修改时间',type:'input'},
            {name:'pay_time',title:'支付时间',type:'input'},
		 ];
	},
    otherFunctions:function(){
      return {
	     ready:function(){
	    },
	    loadSuccess:function(info){
            if(info.totalAmount){
                $("#totalAmount").val((parseInt(info.totalAmount)/100).toFixed(2));
            }
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
