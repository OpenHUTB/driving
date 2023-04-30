var modelConfig = {
    title: '内部客户退款记录',pkey:'id',type:'snow',orderBy: 'update_time Desc',db:"park",
    namespace: "pay_inside_refund_r",table:'t_pay_inside_refund',dp:JSON.stringify({park_id:'parkIds'}),
    exjs:'${path.staticPath}/js/My97DatePicker/WdatePicker.js',isMultiTenant:true
};
var listPage={
    listFieldSett:function(){
        return [
            {name: 'parkName', title: '停车场名称',width:'15%',align:'center'},
            {name: 'ownerName', title: '客户姓名',width:'15%',align:'center'},
            {name: 'ownerMobile', title: '电话',width:'15%',align:'center' },
            {name: 'plateNums', title: '车牌号',width:'15%',align:'center'},
            {name: 'refund_amont', title:'退款金额',width:'10%',align:'center'},
            {name: 'deduct_give_amount', title: '退赠送金额',width:'10%',align:'center'},
            {name: 'service_amount', title: '退款手续费',width:'10%',align:'center'},
            {name: 'monthly_end_date', title: '月租提前结束日期',width:'10%',align:'center'},
            {name: 'is_contract', title: '是否是月租户充值',width:'10%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.is_contractName'},
            {name: 'createUser',title:'操作人',width:'10%',align:'center',trans:'user',showField:'transMap.create_userUserName'},
            {name: 'create_time', title: '操作时间',width:'15%',align:'center'},
        ]},
    isColumnButton:function(){
        return  true;
    },
    filters:function(){
        return [
            {name:'park_id',type:'select',url:'${path.basePath}/ms/x/parking/findListData',
                valuefield:'id',textfield:'parkName',title:'停车场',showAll: true},
            {name: 'ownerName',type:'input',title:'客户姓名',filterType:'like'},
            {name: 'ownerMobile',type:'input',title:'电话',filterType:'like'},
            {name: 'plateNums',type:'input',title:'车牌号',filterType:'like'},
            {name: 'create_time', type: 'dateBT', title: '退款时间',isBT:true},
        ];
    },
    buttons: function () {
        return [
        ];
    },
    disableButtons: function () {
        return ["view","add","update","delete","export"];
    },
    otherFunctions: function(){
        return {
            onListPageReady:function(){
                var currentdate = getNowTime("yyyy-MM-dd");
                $('#createTime_start_F').val(currentdate + " 00:00:00");
                $('#createTime_end_F').val(currentdate + " 23:59:59");
                //增加 尾行
                var LoadNum = 0;
                setTimeout(function(){
                    $('#listGrid').datagrid({
                        url:'${path.basePath}/ms/pay_inside_refund_r/findPageByRefund',
                        queryParams:getGridParam(),
                        showFooter: true,
                        onLoadSuccess:function(data){
                            if(data.total == 0){
                                LoadNum =LoadNum+1;
                                if(LoadNum > 1){
                                    Ealert("暂无记录")
                                }
                            }
                        },
                    });
                },100);
            },
        }
    }
};
var add={
    formFields:function(){
        return [
        ];
    },
    otherFunctions:function(){
        return {
            ready: function () {
            },
            loadSuccess: function (info) {
            },
            onSave: function () {
            },
            saveSucess: function () {
            },
            saveError: function () {
            }
        }
    }
}
