var modelConfig = {title: '临时订单',pkey: 'id',type: 'snow',namespace: "pay_temp_order",table: 't_pay_temp_order',
    trans: true,db: "park",dp: JSON.stringify({park_id: 'parkIds'}),isMultiTenant: true,dataGridUrl:'${path.basePath}/ms/pay_temp_order_history/queryPager',
    exjs: '${path.basePath}/js/park_util.js,${path.staticPath}/js/dayjs.min.js',isNotTotal:true,infoUrl:'${path.basePath}/ms/pay_temp_order_history/detail?id=',
};

var listPage = {
    listFieldSett: function () {
        return [
            {name: 'order_no', title: '支付网关订单号', width: '10%', align: 'center'},
            {name: 'park_id',title:'停车场名称',width:'20%',align:'center',trans:'simple',target:'com.xhb.park.bean.ParkParking',field:'parkName',showField:'transMap.parkName'},
            {name: 'enterPort',title: '入口名称',width: '10%',align: 'center',trans:'simple',target:'com.xhb.park.bean.ParkParkingPort',field:'portName',alias:'enterPort',showField:"transMap.enterPortPortName"},
            {name: 'portId',title: '出口名称',width: '10%',align: 'center',trans:'simple',target:'com.xhb.park.bean.ParkParkingPort',field:'portName',showField:"transMap.portName"},
            {name: 'plate_number', title: '车牌号', width: '10%', align: 'center'},
            {name: 'car_record_type', title: '车辆性质', width: '10%', align: 'center',trans:'book',key:'car_record_type',showField:'transMap.car_record_typeName'},
            {name: 'enter_time', title: '入场时间', width: '15%', align: 'center'},
            {name: 'out_time', title: '出场时间', width: '15%', align: 'center'},
            {name: 'order_status',title: '订单状态',width: '10%',align: 'center',trans: 'book',key: 'temp_order_status',showField: 'transMap.order_statusName'},
            {name: 'pay_type',title: '支付方式',width: '10%',align: 'center',trans: 'book',key: 'pay_type',showField: 'transMap.pay_typeName'},
            {name: 'total_amount', title: '应收金额', width: '10%', align: 'center'},
            {name: 'pay_order_no', title: '第三方支付订单号', width: '10%', align: 'center'},
            {name: 'create_time', title: '创建时间', width: '15%', align: 'center'},
            {name: 'payTime', title: '支付时间', width: '15%', align: 'center'},
            {name:'is_sync',title:'是否已下发',width:'10%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.is_syncName'},
            {name: 'is_online',title: '缴费方式',width: '10%',align: 'center',trans:'book',key:'is_online',showField:'transMap.is_onlineName'},
            {name: 'actual_amount', title: '应补金额', width: '6%', align: 'center'},
            {name: 'discount_amount', title: '优惠金额', width: '6%', align: 'center'},
            /*{name:'offline_pay_type',title:'线下支付方式',width:'10%',align:'center',trans: 'book',key: 'offline_pay_type',showField: 'transMap.offline_pay_typeName'},*/
            {name: 'parking_time', title: '停车用时', width: '10%', align: 'center', formart: 'minuteTo'},
            {name: 'collectorName', title: '收费员', width: '10%',align: 'center',trans:'simple',target:'com.xhb.park.bean.UcenterTollCollector',field:'name',alias:'user',showField:'transMap.userName'},
            {name: 'cash_pay', title: '现金支付金额', width: '6%',align:'center'},
            {name: 'gate_pay', title: '网络支付金额', width: '6%',align:'center'},
            /*{name: 'cash_coupon_pay', title: '代金券支付金额', width: '6%',align:'center'},*/
            {name: 'balance_pay', title: '余额支付金额', width: '6%',align:'center'},
            /*{name: 'integral_pay', title: '积分支付金额', width: '6%',align:'center'},*/
            {name: 'special_pay', title: '特殊放行损失', width: '6%',align:'center'},
            /*{name: 'cash_coupon_hours', title: '代金券抵扣时长', width: '6%',align:'center'},
            {name: 'cash_coupon_radio', title: '代金券优惠额度', width: '6%',align:'center'},*/
            {name: 'detail', title: '详情', width: '15%',align:'center'},
            /*{name: 'syn_status',title:'同步状态',width:'10%',align:'center',trans: 'book',key: 'syn_status',showField: 'transMap.syn_statusName'},*/
            {name: 'lifting_rod_time', title: '抬杆时间', width: '15%',align:'center'},
            {name: 'car_type',title:'车辆类型',width:'10%',align:'center',trans: 'book',key: 'car_type',showField: 'transMap.car_typeName'},
            {name: 'enterId', title: '入场记录id',hidden: "true"},
            {name: 'outId', title: '出场记录id',hidden: "true"},
        ]
    },
    isColumnButton: function () {
        return false;
    },
    filters: function () {
        return [
            {
                name: 'park_id', type: 'select', url: '${path.basePath}/ms/x/parking/findListData',
                valuefield: 'id', textfield: 'parkName', title: '停车场', showAll: true, width: '500'
            },
            {name: 'plate_number', type: 'input', title: '车牌号', filterType: 'like'},
            {name: 'enter_time', type: 'dateBT', title: '出入场时间', isBT: true},
            {name: 'pay_time', type: 'dateBT', title: '支付时间', isBT: true},
            {
                name: 'collector_id',
                type: 'select',
                title: '收费员',
                url: '${path.basePath}/ms/x/ucenter_toll_collector/findListData',
                valuefield: 'collectorId',
                textfield: 'name',
                showAll: true
            },
            {name: 'order_status', title: '订单状态', type: 'book', code: 'temp_order_status', showAll: true},
        ];
    },
    buttons: function () {
        return [
            /*{title: '订单每日费用计算结果列表', fun: 'childOrderDay', permissionsCode: 'pay_temp_order_fee_day:see', isRow: true},
            {
                title: '结余计算结果列表',
                fun: 'childOrderBalance',
                permissionsCode: 'pay_temp_order_fee_balance:see',
                isRow: true
            },*/
            {title: '查看入场图片', fun: 'carEnterImg', permissionsCode: 'pay_temp_order:see', isRow: true},
            {title: '查看出场图片', fun: 'carExitImg', permissionsCode: 'pay_temp_order:see', isRow: true},
            {title:'导出',fun:'exportReportExcel',permissionsCode:'pay_temp_order:see',isRow:false,}
        ];
    },
    disableButtons: function () {
        return ["add", "update", "delete","export"];
    },
    otherFunctions: function () {
        return {
            childOrderDay: function (row) {
                var _openFrameMsg = {
                    url: '${path.basePath}/ms/pagex/pay_temp_order_fee_day_list.jsp?temp_order_id=' + row.id,
                    title: row.plateNumber + '订单每日费用计算结果列表'
                }
                top.postMessage(_openFrameMsg, '*');
            },
            childOrderBalance: function (row) {
                var _openFrameMsg = {
                    url: '${path.basePath}/ms/pagex/pay_temp_order_fee_balance_list.jsp?temp_order_id=' + row.id,
                    title: row.plateNumber + '订单结余计费结果列表'
                }
                top.postMessage(_openFrameMsg, '*');
            },
            carEnterImg: function (row) {
                openDialog('${path.basePath}/b/page-ms-temp_order/view_car_img?id='
                    + row.enterId,
                    '查看入场图片');
            },
            carExitImg: function (row) {
                openDialog('${path.basePath}/b/page-ms-temp_order/view_car_img?id='
                    + row.outId,
                    '查看出场图片');
            },
            timeFormat: function (_val, _row, _index) {
                if (_val) {
                    var year = _val.substr(0, 4);
                    var month = _val.substr(4, 2);
                    var day = _val.substr(6, 2)
                    var hour = _val.substr(8, 2);
                    var minute = _val.substr(10, 2);
                    var second = _val.substr(12, 2);
                    return year + "-" + month + "-" + day + " " + hour + ":" + minute + ":" + second;
                }
                return '';
            },
            onListPageReady: function () {
                if ('${param.collectorId}' != '') {
                    $('#collectorIdF').combobox('setValue', '${param.collectorId}');
                    $('#parkIdF').combobox('setValue', '${param.parkId}');
                    $('#payTime_start_F').val('${param.payTime}' + ' 00:00:00');
                    $('#payTime_end_F').val('${param.payTime}' + ' 23:59:59');
                    if ('${param.type}' == 'pay') {
                        $('#orderStatusF').combobox('setValue', 1);
                    }
                    if ('${param.type}' == 'free') {
                        $('#orderStatusF').combobox('setValue', 2);
                    }
                    $('#listGrid').datagrid({
                        url:'${path.basePath}/ms/pay_temp_order_history/queryPager',
                        queryParams:getGridParam()
                    });
                }
            },

            minuteTo: function (menuts, _row, _index) {
                return toHourMinute(menuts);
            },
            paramHandle: function (_sourceParam) {
                if(_sourceParam.payTimeMin){
                    _sourceParam.payTimeMin = dayjs(_sourceParam.payTimeMin).format("YYYYMMDDHHmmss");
                }
                if(_sourceParam.payTimeMax){
                    _sourceParam.payTimeMax = dayjs(_sourceParam.payTimeMax).format("YYYYMMDDHHmmss");
                }
                return _sourceParam;
            },
            exportReportExcel:function(){
                //先刷新，在用ajax提交
                reload();
                var _fieldArray = getExcelFields();
                var parkIdF = $("#parkIdF").combobox('getValue');
                if(parkIdF == ""){
                    Ealert("停车场不能为空");
                    return;
                }
                setTimeout(function(){
                    $.ajax({
                        url: "${path.basePath}/ms/pay_temp_order_history/exportReportHistoryExcel",
                        type: "post",
                        contentType: "application/json;charset=utf-8",
                        dataType: "json",
                        success: function (result) {
                            if (result.code == 400) {
                                EalertE(result.message);
                            } else {
                                Ealert("excel文件正在生成，请稍后在报表夹下载！")
                            }
                        }
                    })
                },1000);
            }
        }
    }
};

var add = {
    formFields: function () {
        return [
            {name: 'order_no', title: '支付网关订单号', type: 'input'},
            {name: 'park_id', type: 'select', url: '${path.basePath}/ms/x/parking/findListData',valuefield: 'id', textfield: 'parkName', title: '停车场名称'},
            {name: 'port_id',type: 'select',url: '${path.basePath}/ms/x/parking_port/findListData',valuefield: 'id',textfield: 'portName',title: '出口名称',required: true},
            {name: 'plate_number', title: '车牌号', type: 'input', dataType: 'plate_number|plate_number_new'},
            {name: 'enter_time', title: '入场时间', type: 'date', formart: 'yyyy-MM-dd HH:mm'},
            {name: 'out_time', title: '出场时间', type: 'date', formart: 'yyyy-MM-dd HH:mm'},
            {name: 'order_status', title: '订单状态', type: 'book', code: 'temp_order_status'},
            {name: 'pay_type', title: '支付方式', type: 'book', code: 'pay_type'},
            {name: 'total_amount', title: '应收金额', type: 'input'},
            {name: 'pay_order_no', title: '第三方支付订单号', type: 'input'},
            {name: 'pay_time', title: '支付时间', type: 'date', formart: 'yyyy-MM-dd HH:mm'},
            {name: 'syn_status', title: '同步状态', type: 'book', code: 'syn_status'},
            {name: 'is_online', title: '缴费方式', type: 'book', code: 'is_online'},
            {name: 'actual_amount', title: '应补金额', type: 'input'},
            {name: 'discount_amount', title: '优惠金额', type: 'input'},
            {name: 'parking_time', title: '停车用时', type: 'input'},
            /*{name:'offline_pay_type',title:'线下支付方式',type: 'book',code: 'offline_pay_type'},*/
            {name:'collector_id',title:'收费员',type:'select',url:'${path.basePath}/ms/x/ucenter_toll_collector/findListData',valuefield:'collectorId',textfield:'name',required:true},
            {name: 'enter_port', title: '入口', type: 'select',url: '${path.basePath}/ms/x/parking_port/findListData',valuefield: 'id',textfield: 'portName'},
            {name: 'cash_pay', title: '现金支付金额', type: 'input'},
            {name: 'gate_pay', title: '网络支付金额', type: 'input'},
            /*{name: 'cash_coupon_pay', title: '代金券支付金额', type: 'input'},*/
            {name: 'balance_pay', title: '余额支付金额', type: 'input'},
/*            {name: 'integral_pay', title: '积分支付金额',type: 'input'},*/
            {name: 'special_pay', title: '特殊放行损失',type: 'input'},
/*            {name: 'cash_coupon_hours', title: '代金券抵扣时长',type: 'input'},
            {name: 'cash_coupon_radio', title: '代金券优惠额度',type: 'input'},*/
            {name: 'is_sync', type: 'hide'}
        ];
    },
    otherFunctions: function () {
        return {
            ready: function () {

            },
            loadSuccess: function (info) {
                $('#payTime').val(timeFormat(info.payTime));
            },
            onSave: function () {
                $('#isSync').val(0);
            },
            saveSucess: function () {
            },
            saveError: function () {

            }
        }
    }
};
var front = {
    apis: function () {
        return [
            {name: 'info', type: 'one', where: 'id'}
        ]
    }
};
