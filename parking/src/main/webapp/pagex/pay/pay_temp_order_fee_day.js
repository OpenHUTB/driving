var modelConfig= {title:'每日费用计算结果',pkey:'id',type:'snow',
    orderBy:'fee_date asc',
    namespace:"pay_temp_order_fee_day",table:'t_pay_temp_order_fee_day',extendsParam:'temp_order_id=${param.temp_order_id}',
    exp:'js',exs:'http://static.fhs.xhb.com/js/My97DatePicker/WdatePicker.js'};
var listPage={
    listFieldSett:function(){
        return [
            {name:'fee_date',title:'收费日期',width:'50%',align:'center'},
            {name:'amount',title:'金额',width:'49%',align:'center'},
        ]},
    isColumnButton:function(){
        return  true;
    },
    filters:function(){
        return [];
    },
    buttons:function(){
        return [
            {title:'订单该天各时间段费用计算结果列表',fun:'childOrderDepict',permissionsCode:'pay_temp_order_fee_depict:see',isRow:true},
        ];
    },
    disableButtons:function(){
        return ["view","add","update","delete"];
    },
    otherFunctions:function(){
        return {
            onListPageReady: function () {
                $('.searchBTN').hide();
            },
            childOrderDepict:function(row){
                var _openFrameMsg = {url:'${path.basePath}/ms/pagex/pay_temp_order_fee_depict_list.jsp?fee_day_id=' + row.id,title:row.feeDate + '日费用计算结果列表'}
                top.postMessage(_openFrameMsg, '*');
            }


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
