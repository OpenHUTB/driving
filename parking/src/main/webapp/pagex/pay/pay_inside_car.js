var modelConfig = {
    title: '月租户管理', pkey: 'id', type: 'snow', orderBy: 'update_time Desc',isOne2X:true,
    namespace: "pay_inside_car", table: 't_pay_inside_car', trans: true,db:"park",dp:JSON.stringify({park_id:'parkIds'}),isMultiTenant: true,
    saveUrl:'${path.basePath}/ms/pay_inside_car/add',updateUrl:'${path.basePath}/ms/pay_inside_car/update',
    joinColumns:JSON.stringify({owner_name:'ownerName'}),exjs:'${path.staticPath}/js/dayjs.min.js,${path.staticPath}/js/My97DatePicker/WdatePicker.js'
};

var listPage = {
    listFieldSett: function () {
        return [
            {name:'park_id',title:'停车场名称',width:'20%',align:'center', trans:'pagex',key:'parking',showField:'transMap.parkName'},
            {name: 'inside_name', title: '内部名称', width: '8%', align: 'center'},
            {name: 'owner_name', title: '车主名称', width: '8%', align: 'center'},
            {name: 'owner_mobile', title: '车主电话', width: '8%', align: 'center'},
            {name: 'lease_type_id',title: '月租户类型',hidden: "true",url:'${path.basePath}/ms/x/parking_lease_type/findListData', isJoin: true, namespace: 'parking_lease_type',showField: 'transMap.leaseName'},
            {name: 'rule_id',title: '月租户收费规则',hidden: "true",url:'${path.basePath}/ms/x/park_monthly_rule/findListData', isJoin: true, namespace: 'park_monthly_rule',showField: 'transMap.ruleName'},
            {name: 'lot_num', title: '占用车位数', width: '5%', align: 'center'},
            {name: 'start_date', title: '开始日期', width: '10%', align: 'center'},
            {name: 'end_date', title: '结束日期', width: '10%', align: 'center'},
            {name: 'end_date', title: '包月剩余天数', width: '10%', align: 'center',handle:'subDays',showField: 'subDays'},
            {name: 'end_date', title: '是否充值过', width: '10%', align: 'center',showField: 'isRecharge'},
            {name: 'plate_nums', title: '车牌号', width: '14%', align: 'center'},
            {name: 'balance', title: '余额',width: '8%', align: 'center'},
            {name:'monthly_type',title:'租赁类型',width: '8%', align: 'center',trans:'book',key:'monthly_type',showField: 'transMap.monthly_typeName'},
            {name:'create_user',title:'创建人',width:'8%',align:'center',trans:'user',showField:'transMap.create_userUserName'},
            {name:'create_time',title:'创建时间',width:'10%',align:'center'},
            {name:'is_sync',title:'是否已下发',width:'5%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.is_syncName'},
        ]
    },
    isColumnButton: function () {
        return false;
    },
    filters: function () {
        return [
            {name:'park_id',type:'select',url:'${path.basePath}/ms/x/parking/findListData',valuefield:'id',textfield:'parkName',title:'停车场',showAll:true},
            /*{name:'region_id',type:'select',url:'${path.basePath}/ms/x/park_region/findListData',valuefield:'id',textfield:'regionName',title:'区域'},*/
            {name:'monthly_type',type:'book',title:'租赁类型',code:'monthly_type',showAll:true},
            {name:'owner_name',type:'input',title:'车主姓名',filterType:'like'},
            {name:'owner_mobile',type:'input',title:'车主电话',filterType:'like'},
            {name:'plate_nums',type:'input',title:'车牌号',filterType:'like'}
        ];
    },
    buttons: function () {
        return [
            {title:'续费',fun:'recharge',permissionsCode:'pay_inside_recharge:update',isRow:true},
            {title:'退款',fun:'refund',permissionsCode:'pay_inside_refund:update',isRow:true},
            {title:'续费记录',fun:'rechargeRecord',permissionsCode:'pay_inside_recharge:see',isRow:true},
            {title:'退款记录',fun:'refundRecord',permissionsCode:'pay_inside_refund:see',isRow:true},
            {title:'账单变动日志',fun:'balanceChangeLog',permissionsCode:'pay_inside_balance_change_log:see',isRow:true},
            {title:'批量导入',fun:'batchImport',permissionsCode:'pay_inside_car:add'},
        ];
    },
    disableButtons: function () {
        return [];
    },
    otherFunctions: function () {

        return {
            recharge:function(record){
                record.roomNum = record.roomNum == null?"":record.roomNum;
                if(record.monthlyType == 3){
                    //免费用户
                    EalertE('免费用户不可以续费噢');
                    return false;
                }else if(record.monthlyType == 4){
                    //储户时段租续费
                    openDialog('${path.basePath}/ms/pagex/pay_inside_recharge_add_update.jsp?isAdd=true&inside_id='+(record.id+'&park_id='+record.parkId+'&owner_mobile='+record.ownerMobile+'&owner_name='+record.ownerName+'&room_num='+record.roomNum+'&lease_type='+record.transMap.leaseName+'&monthly_type_name='+record.transMap.monthlyTypeName+'&plate_nums='+record.plateNums+'&create_time='+record.createTime).replaceAll(" ","%20"),'储户时段租续费');
                }else{
                    //月租续费
                    openDialog('${path.basePath}/ms/pagex/pay_inside_contract_add_update.jsp?isAdd=true&inside_id='+(record.id+'&park_id='+record.parkId+'&lot_num='+record.lotNum+'&owner_mobile='+record.ownerMobile+'&owner_name='+record.ownerName+'&room_num='+record.roomNum+'&lease_type='+record.transMap.leaseName+'&monthly_type_name='+record.transMap.monthlyTypeName+'&start_date='+record.startDate+'&end_date='+record.endDate+'&monthly_type='+record.monthlyType+'&lease_type_id='+record.leaseTypeId+'&plate_nums='+record.plateNums+'&create_time='+record.createTime).replaceAll(" ","%20"), '月租续费');
                }
            },
            rechargeRecord:function(record){
                if(record.monthlyType == 3){
                    //免费用户
                    EalertE('免费用户没有续费记录噢');
                    return false;
                }else if(record.monthlyType == 4){
                    //储户时段租续费
                    openIframeDialog('${path.basePath}/ms/pagex/pay_inside_recharge_list.jsp?inside_id=' + (record.id + '&park_id=' + record.parkId+'&owner_mobile='+record.ownerMobile+'&owner_name='+record.ownerName).replaceAll(" ","%20"),'续费记录');
                }else{
                    //月租续费
                    openIframeDialog('${path.basePath}/ms/pagex/pay_inside_contract_list.jsp?inside_id=' + (record.id + '&park_id=' + record.parkId+'&owner_mobile='+record.ownerMobile+'&owner_name='+record.ownerName).replaceAll(" ","%20"),'续费记录');
                }
            },
            refundRecord:function(record){
                if(record.monthlyType == 3){
                    EalertE('免费用户没有退费记录噢');
                    return false;
                }
                openIframeDialog('${path.basePath}/ms/pagex/pay_inside_refund_list.jsp?inside_id=' + record.id,'退款记录');
            },
            reloadRegionF:function(record){
                $('#regionIdF').combobox('clear');
                $('#regionIdF').combobox('reload', '${path.basePath}/ms/x/park_region/findListData?park_id=' + record.id);
            },
            refund:function(record){
                record.roomNum = record.roomNum == null?"":record.roomNum;
                if(record.monthlyType == 3){
                    EalertE('免费用户无法续费,无法退款!');
                    return false;
                }else if(record.monthlyType == 4){
                    //储户时段租退款
                    if(record.balance <= 0){
                        EalertE("该用户已经没有余额了,无法退款");
                        return false;
                    }
                    //查询最后一条储户时段租用户续费记录
                    $.get({url:'${path.basePath}ms/pay_inside_recharge/findLastInfo/'+record.id,success:function(res){
                            if(res.code != 200){
                                EalertE("Sorry,未找到该储户时段租用户续费记录,无法退款");
                                return false;
                            }
                            openDialog('${path.basePath}ms/pagex/pay_inside_refund_add_update.jsp?isAdd=true&owner_name='+(record.ownerName+'&owner_mobile='+record.ownerMobile+'&monthly_type='+record.monthlyType+'&inside_id=' + record.id + '&park_id=' + record.parkId+'&balance='+record.balance+'&lot_num='+record.lotNum+'&room_num='+record.roomNum+'&lease_type='+record.transMap.leaseName+'&monthly_type_name='+record.transMap.monthlyTypeName+'&amount='+res.data.amount+'&give_amount='+res.data.giveAmount).replaceAll(" ","%20"), '储户时段租退款');
                        },dataType:'json'});
                }else{
                    //查询最后一条月租用户续费记录
                    var contractId = null;
                    var endDate = null;
                    $.get({url:'${path.basePath}ms/pay_inside_contract/findLastInfo/'+record.id,success:function(res){
                            if(res.code != 200){
                                EalertE("Sorry,未找到该月租用户的续费记录,无法退款");
                                return false;
                            }
                            if(res.data.endDate < getNowTime('yyyy-MM-dd')){
                                EalertE("Sorry,月租到已经结束,无法退款");
                                return false;
                            }
                            openDialog('${path.basePath}ms/pagex/pay_inside_refund_add_update.jsp?isAdd=true&owner_name='+(record.ownerName+'&owner_mobile='+record.ownerMobile+'&monthly_type='+record.monthlyType+'&inside_id=' + record.id + '&park_id=' + record.parkId+'&lot_num='+record.lotNum+'&room_num='+record.roomNum+'&lease_type='+record.transMap.leaseName+'&monthly_type_name='+record.transMap.monthlyTypeName+'&contract_id='+res.data.id+'&end_date='+res.data.endDate).replaceAll(" ","%20"), '月租退款');
                        },dataType:'json'});
                }
            },
            batchImport:function(row){
                openDialog('${path.basePath}/b/page-ms-park/pay_inside_car_batch_import','批量导入');
            },
            balanceChangeLog:function(record){
                if(record.monthlyType == 3){
                    EalertE('免费用户不会产生账单变动日志哦');
                    return false;
                }
                openIframeDialog('${path.basePath}/ms/pagex/pay_inside_balance_change_log_list.jsp?inside_id=' + record.id,'账单变动记录');
            }
        }
    }
};

var add = {
    formFields: function () {
        return [

            {title: '内部客户信息', type: 'group'},
            {name: 'inside_name', title: '内部名称', required: true, type: 'input'},
            /*{name: 'first_type', title: '一级分类', type: 'input'},
            {name: 'second_type', title: '二级分类', type: 'input'},
            {name: 'three_type', title: '三级分类', type: 'input'},*/
            {name: 'owner_name', title: '车主名称', required: true, type: 'input'},
            {name: 'owner_mobile', title: '车主电话', type: 'input',dataType: 'tel|tel_p'},
            /*{name: 'room_num', title: '房间号', type: 'input'},*/
            {name: 'park_id', title:'停车场名称', type:'select',url:'${path.basePath}/ms/x/parking/findListData',valuefield:'id',textfield:'parkName',required:true,onSelect:'reloadPark',onLoadSuccess:'defaultSelect'},
            {name: 'lot_num', title: '占用车位数',required: true, type: 'input', dataType: 'n1-3'},
            {name: 'lease_type_id',title: '内部类型', type:'select',url:'',valuefield:'id',textfield:'leaseName',required:true},
            {name: 'rule_id',title: '收费规则', type:'select',url:'',valuefield:'id',textfield:'ruleName',required:true,onSelect:'reloadMonthlyType'},
            {name:'monthly_type',title:'租赁类型',type:'hide'},
            {name: 'start_date', title: '开始日期', required: true, type: 'hide'},
            {name: 'end_date', title: '结束日期', required: true, type: 'hide'},
            {name:'remark',title:'备注',type:'text'},
            {name:'img',title:'图片',type:'up',placeholder:'请上传图片'},
            {type:'divStart',id:'hideDiv',style:'display:none;'},
            {name: 'balance', title: '余额',type: 'input'},
            {type:'divEnd'},
            {name:'plate_nums',title:'车牌号',type:'hide'},
            {name: 'is_sync',type:'hide'},
            {title: '车牌绑定',type:'one2x',namespace:'pay_inside_plate_bind'},
            /*{type:'divStart',id:'regionLotDiv',style:'display:none;'},
            {title:'区域车位',type:'one2x',namespace:'park_region_lot',allowEdit:false},
            {type:'divEnd'}*/
        ];
    },
    otherFunctions: function () {
        return {
            ready: function () {
                $('#balance').val(0);
                if('${param.isView}'=='true'){
                    $('#hideDiv').show();
                    $('#regionLotDiv').show();
                }
                $("#lotNum").val(1);
            },
            loadSuccess: function (info) {
                var parkId = info.parkId;
                //$('#regionId').combobox('reload', '${path.basePath}/ms/x/park_region/findListData?park_id=' + parkId);
                $('#leaseTypeId').combobox('reload', '${path.basePath}/ms/x/parking_lease_type/findListData?isDisable=0&parkId=' + parkId);
                $('#ruleId').combobox('reload', '${path.basePath}/ms/x/park_monthly_rule/findListData?isDisable=0&parkId=' + parkId);
                $('#tagIds_select').combobox('reload','${path.basePath}/ms/x/pay_monthly_tag_config/findListData?park_id=' + parkId);
            },
            onSave: function () {
                $('#isSync').val(0);
                var _plateNumbers = str2json($('#pay_inside_plate_bind').val());
                $('#plateNums').val('');
                _plateNumbers.forEach(function(_item){
                    _item.isSync=0;
                    _item.parkId = $('#parkId').combobox('getValue');
                    if($('#plateNums').val()!='')
                    {
                        $('#plateNums').val($('#plateNums').val() + ',');
                    }
                    $('#plateNums').val($('#plateNums').val() + _item.plateNumber);
                });
                $('#pay_inside_plate_bind').val(json2str(_plateNumbers));
            },
            saveSucess: function () {
            },
            saveError: function () {
            },
            getConflictMsg:function(){
                return '同一个停车场内的客户不允许绑定重复的车牌号';
            },
            reloadPark:function(record){
                //$('#regionId').combobox('clear');
                //$('#regionId').combobox('reload', '${path.basePath}/ms/x/park_region/findListData?park_id=' + record.id);
                $('#leaseTypeId').combobox('clear');
                $('#leaseTypeId').combobox('reload', '${path.basePath}/ms/x/parking_lease_type/findListData?isDisable=0&parkId=' + record.id);
                $('#ruleId').combobox('clear');
                $('#ruleId').combobox('reload','${path.basePath}/ms/x/park_monthly_rule/findListData?isDisable=0&parkId=' + record.id);
                $('#tagIds_select').combobox('clear');
                $('#tagIds_select').combobox('reload','${path.basePath}/ms/x/pay_monthly_tag_config/findListData?park_id=' + record.id);
            },
            reloadMonthlyType:function(record){
                $('#monthlyType').val(record.monthlyType);
            },
            defaultSelect:function(){
                if('${param.isAdd}'=='true'){
                    var data = $('#parkId').combobox('getData');
                    $('#parkId').combobox('select',data[0].id);
                }
            }
        }
    }
}
