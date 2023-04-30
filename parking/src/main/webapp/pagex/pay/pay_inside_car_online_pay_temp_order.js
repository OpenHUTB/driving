var modelConfig= {title:'网络月租订单',pkey:'id',type:'snow', orderBy:'update_time Desc',
    namespace:"pay_inside_car_online_pay_temp_order",table:'t_pay_inside_car_online_pay_temp_order',trans:true,
    isMultiTenant:true,dp:JSON.stringify({park_id:'parkIds'}),exjs:'${path.staticPath}/js/My97DatePicker/WdatePicker.js',
};
var listPage={
    listFieldSett:function(){
        return [
            {name:'park_id',title:'停车场名称',width:'20%',align:'center',trans:'simple',target:'com.xhb.park.bean.ParkParking',field:'parkName',showField:'transMap.parkName'},
            {name: 'name',title:'用户姓名',width:'10%',align:'center'},
            {name: 'mobile',title:'手机号',width:'10%',align:'center'},
            /*{name: 'property_fee',title:'物业费用',width:'10%',align:'center'},
            {name: 'property_fee_status',title: '物业费用状态',width: '10%',align: 'center',trans: 'book',key: 'fee_status',showField: 'transMap.property_fee_statusName'},*/
            {name: 'lot_num',title:'车位数量',width:'10%',align:'center'},
            {name: 'monthly_fee',title:'停车费费用',width:'10%',align:'center'},
            {name: 'monthly_fee_status',title: '停车费用状态',width: '10%',align: 'center',trans: 'book',key: 'fee_status',showField: 'transMap.monthly_fee_statusName'},
            {name:'create_time',title:'创建时间',width:'15%',align:'center'},
            {name: 'start_date',title:'开始生效日期',width:'10%',align:'center'},
            {name: 'end_date',title:'结束生效日期',width:'9%',align:'center'},
        ]},
    isColumnButton:function(){
        return  true;
    },
    filters:function(){
        return [
            {name:'park_id',type:'select',url:'${path.basePath}/ms/x/parking/findListData',valuefield:'id',textfield:'parkName',title:'停车场',showAll:true},
            {name:'name',type:'input',title:'姓名',filterType:'like'},
            {name:'mobile',type:'input',title:'电话',filterType:'like'},
            /*{name:'property_fee_status',title:'物业费费用状态',type:'book',code:'fee_status',showAll:true},*/
            {name:'monthly_fee_status',title:'停车费费用状态',type:'book',code:'fee_status',showAll:true},
            {name: 'create_time', type: 'dateBT', title: '创建时间',isBT:true},
        ];
    },
    buttons:function(){
        return [
        ];
    },
    disableButtons:function(){
        return ["add","update","delete"];
    },
    otherFunctions:function(){
        return {
        }
    }
};

var add={
    formFields:function(){
        return [
            {name: 'park_id',type:'select',url:'${path.basePath}/ms/x/parking/findListData',valuefield:'id',textfield:'parkName',title:'停车场名称',required:true},
            {name: 'name', title: '用户姓名' ,type:'input'},
            {name: 'mobile', title: '手机号' ,type:'input'},
            {name: 'property_fee', title: '物业费' ,type:'input'},
            {name: 'property_fee_status', title: '物业费费用状态', type: 'book', code: 'fee_status'},
            {name: 'property_fee_order_no', title: '物业费订单号' ,type:'input'},
            {name: 'lot_num', title: '车位数量' ,type:'input'},
            {name: 'start_date', title: '开始生效日期' ,type:'input'},
            {name: 'end_date', title: '结束生效日期' ,type:'input'},
            {name: 'monthly_fee', title: '停车费' ,type:'input'},
            {name: 'monthly_fee_status', title: '停车费费用状态', type: 'book', code: 'fee_status'},
            {name: 'monthly_fee_order_no', title: '停车费订单号' ,type:'input'},
            /*{name: 'property_fee_pay_time', title: '物业费支付时间' ,type:'input'},
            {name: 'property_fee_return_time', title: '物业费退款时间' ,type:'input'},*/
            {name: 'monthly_fee_pay_time', title: '停车费付款时间' ,type:'input'},
            {name: 'monthly_fee_return_time', title: '停车费退款时间' ,type:'input'},
            {name: 'lot_ids', type:'select',url:'${path.basePath}/report/parkRegionLot/getLotNOAndRegionName', valuefield:'id',textfield:'lotNo',title:'车位',multiple:true},
            {name: 'monthly_rule_id',title:'计费规则',type:'select',url:'${path.basePath}/ms/x/park_monthly_rule/findListData',valuefield:'id',textfield:'ruleName',required:true},
            {name: 'inside_id',title:'内部客户',type:'select',url:'${path.basePath}/ms/x/pay_inside_car/findListData',valuefield:'id',textfield:'ownerName',required:true},
            {name: 'time_out_time', title: '超时时间' ,type:'input'},
            {name: 'month_num', title: '月数' ,type:'input'},
            {name: 'create_time',title:'创建时间',type:'input'},
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
