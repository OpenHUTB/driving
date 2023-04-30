var modelConfig= {title:'商户充值记录',pkey:'id',type:'uuid', orderBy:'update_time Desc',exjs:'${path.staticPath}/js/math.js',
    namespace:"business_recharge_apply",table:'t_business_recharge_apply',trans:true,isMultiTenant:true,db:"park",dp:JSON.stringify({park_id:'parkIds'})
};
var listPage={
    listFieldSett:function(){
        return [
            {name:'park_id',title:'所属停车场',width:'10%',trans:'pagex',key:'parking',showField:'transMap.parkName',align:'center'},
            {name:'merchant_id',title:'商户名称',width:'10%',align:'center',trans:'pagex', key:'business_merchant', showField:'transMap.merchantName'},
            {name:'agent_name',title:'经办人姓名',width:'10%',align:'center'},
            {name:'agent_phone',title:'经办人电话',width:'10%',align:'center'},
            {name:'recharge_amount',title:'充值金额',width:'10%',align:'center'},
            {name:'discount_radio',title:'折扣',width:'10%',align:'center',formart : 'showDiscount'},
            {name:'payment_amount',title:'实付金额',width:'10%',align:'center'},
            {name:'status',title:'状态',width:'10%',align:'center',trans:'book',key:'apply_status',showField:'transMap.statusName'},
            {name:'create_time',title:'申请时间',width:'15%',align:'center'},
            {name:'confirm_pay_time',title:'打款时间',width:'15%',align:'center'},
            {name:'confirm_receive_time',title:'确认打款时间',width:'15%',align:'center'},
            //存放的是当前用户ID
            {name:'confirm_receive_user_id',title:'确认收款人',width:'10%',align:'center',trans:'sysUser',showField:'transMap.confirmReceiveUserIdUserName'},

        ]},
    isColumnButton:function(){
        return  true;
    },
    filters:function(){
        return [
            {name:'merchant_id',type:'select',url:'${path.basePath}/ms/x/business_merchant/findListData', valuefield:'id',textfield:'merchantName',title:'商户名称',showAll:true},
            {name:'status',type:'book',title:'状态',code:'apply_status',showAll:true},
        ];
    },
    buttons:function(){
        return [
            {title:'确认收款',id:"confirm",fun:'confirmReceive',permissionsCode:'business_recharge_apply:see',isRow:true},
        ];
    },
    disableButtons:function(){
        return ["add","update","delete"];
    },
    otherFunctions:function() {
        return {
            showDiscount : function(_val,row,index){
                if(_val){
                    if(_val == 100){
                        return "无折扣"
                    }
                    return math.divide(_val, 10) +"折";
                }
            },
            confirmReceive : function(row){
                var apply = 1; //申请状态
                var confirm = 3; //已确认收款
                if(row.status==apply ){
                    EalertE("申请状态，不能确认收款");
                    return;
                }
                if(row.status==confirm){
                    EalertE("已确认收款，不可再次确认收款");
                    return;
                }
                $.ajax({
                    method: 'post',
                    url: '${path.basePath}/ms/business_merchant/confirmReceive',
                    dataType: 'json',
                    data:{id:row.id, parkId:row.parkId, merchantId:row.merchantId, rechargeAmount:row.rechargeAmount, paymentAmount:row.paymentAmount, agentPhone:row.agentPhone},
                    success: function (result) {
                        if (result.code == 400) {
                            EalertE(result.message);
                        }else{
                            Ealert("确认收款成功");
                            reload();
                        }
                    }
                })
            }
        }
    }
};
var add={
    formFields:function(){
        return [
            {name:'park_id', title:'所属停车场', type:'select',url:'${path.basePath}/ms/x/parking/findListData', valuefield:'id',textfield:'parkName',required:true},
            {name:'merchant_id', title:'商户名称', type:'select',url:'${path.basePath}/ms/x/business_merchant/findListData', valuefield:'id',textfield:'merchantName',required:true},
            {name: 'agent_name', title: '经办人姓名', required: true, type: 'input'},
            {name: 'agent_phone', title: '经办人电话', required: true, type: 'input'},
            {name: 'recharge_amount', title: '充值金额', required: true, type: 'input'},
            {name: 'discount_radio', title: '折扣', required: true, type: 'input'},
            {name: 'payment_amount', title: '实付金额', required: true, type: 'input'},
            {name: 'status', title: '状态', type: 'book', code: 'apply_status', required: true},
            {name: 'create_time', title: '申请时间', required: true, type: 'input'},
            {name: 'confirm_pay_time', title: '打款时间', required: true, type: 'input'},
            {name: 'confirm_receive_time', title: '确认打款时间', required: true, type: 'input'},
        ];
    },
    otherFunctions:function(){
        return {
            ready:function(){
            },
            loadSuccess:function(info){
                $('#discountRadio').val(showDiscount(info.discountRadio));
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