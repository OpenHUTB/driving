var modelConfig = {
    title: '', pkey: 'id', type: 'snow', orderBy: 'update_time Desc',
    namespace: "pay_inside_contract", table: 't_pay_inside_contract', trans: true,isMultiTenant: true,saveUrl:'${path.basePath}/ms/pay_inside_contract/contractAdd',
    extendsParam:'inside_id=${param.inside_id}',exjs: '${path.basePath}/js/park_util.js,${path.staticPath}/js/dayjs.min.js,${path.staticPath}/js/My97DatePicker/WdatePicker.js',db:"park",dp:JSON.stringify({park_id:'parkIds'})
};

var listPage = {
    listFieldSett: function () {
        return [
            {name: 'start_date', title: '开始日期', width: '10%', align: 'center'},
            {name: 'end_date', title: '结束日期', width: '10%', align: 'center'},
            {name: 'is_by_month', title: '续费类型', width: '10%', align: 'center', trans: 'book', key: 'is_by_month', showField: 'transMap.is_by_monthName'},
            {name: 'amount',title:'续费金额',width:'8%',align:'center'},
            {name: 'lease_month_num', title:'租赁月数', width:'8%' ,align: 'center'},
            {name: 'give_month_mum', title: '赠送月数', width: '8%', align: 'center'},
            {name: 'give_day_num', title: '赠送天数', width: '8%', align: 'center'},
            {name: 'from_type', title: '所属类型', width: '11%', align: 'center',  trans: 'book', key: 'from_type', showField: 'transMap.from_typeName'},
            {name:'is_notice',title:'是否提醒过交费',width:'8%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.is_noticeName'},
            {name:'create_user',title:'操作人',width:'9%',align:'center',trans:'sysUser',showField:'transMap.create_userUserName'},
            {name:'is_sync',title:'是否已下发',width:'9%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.is_syncName'},
        ]
    },
    isColumnButton: function () {
        return false;
    },
    filters: function () {
        return [
            {name:'from_type',type:'book',code:'from_type',title:'所属类型',showAll:true},
        ];
    },
    buttons: function () {
        return [];
    },
    disableButtons: function () {
        return ['add','delete','update'];
    },
    otherFunctions: function () {
        return {
            onListPageReady:function(){
            },
            setExcelName:function () {
                return "续费记录列表";
            }
        }
    }
};

var add = {
    formFields: function () {
        return [
            {name:'park_id',type:'hide',title:'停车场',required:true},
            {name:'inside_id',type:'hide',title:'内部用户',required:true},
            {type:'divStart',id:'ownerInfoDiv',style:'display:none;'},
            {class:'owner_name',type:'input',title:'车主名称'},
            {class:'owner_mobile',type:'input',title:'车主电话'},
            {class:'plate_nums',type:'input',title:'车牌号'},
            {class:'lease_type',type:'input',title:'月租户类型'},
            {class:'start_date',type:'input',title:'月租开始时间'},
            {class:'end_date',type:'input',title:'月租结束时间'},
            {class:'monthly_type_name',type:'input',title:'租赁类型'},
            {class:'create_time',type:'input',title:'创建时间'},
            /*{class:'room_num',type:'input',title:'房间号'},*/
            {type:'divEnd'},
            {name: 'rule_id',title: '收费规则', type:'select',url:'',valuefield:'id',textfield:'ruleName',required:true,onSelect:'getDefaultEndDate'},
            {name:'lot_num',title:'车位数',type:'input',dataType:'n1-2',required:true,onchange:'reloadAmount()'},
            {name: 'start_date', title: '续费开始日期',required: true, type: 'date',formart:'yyyy-MM-dd',onpicked:'countAmount(this)'},
            {name: 'end_date', title: '续费结束日期', required: true, type: 'date',formart:'yyyy-MM-dd',onpicked:'countAmount(this)'},
            {name: 'give_month_mum', title: '赠送月数', type: 'input',onchange:'reloadAmount()'},
            {name: 'give_day_num', title: '赠送天数', type: 'input', dataType: 'n1-3',onchange:'reloadAmount()'},
            {name: 'lease_month_num', title: '租赁月数', type:'input',readonly:'readonly'},
            {name:'amount',title:'租金总计',type:'input',dataType:'n1-6|double2',required:true},
            {name:'remark',title:'备注',type:'text'},
            {name:'is_notice',type:'hide',title:'是否提醒过交费'},
            {name: 'is_sync',type:'hide'},
            {name: 'is_by_month', title: '续费类型', required: true, type:'hide'},
            {class:'unit_price',type:'hide',title:'单价'},
            {class:'max_date',title:'最大包月时间',type:'hide'},
            {class:'min_month',title:'最小租赁月数',type:'hide'},

        ];
    },
    otherFunctions: function () {
        return {
            ready: function () {
                if('${param.isAdd}' == 'true'){
                    $('#leaseMonthNum').val(0);
                    $('#giveMonthMum').val(0);
                    $('#giveDayNum').val(0);
                    $('#amount').val(0);
                    $('#isByMonth').val(0);
                    $("#insideId").val('${param.inside_id}');
                    $("#parkId").val('${param.park_id}');
                    $('.owner_name').val('${param.owner_name}');
                    $('.owner_mobile').val('${param.owner_mobile}');
                    $('.room_num').val('${param.room_num}');
                    $('.plate_nums').val('${param.plate_nums}');
                    $('.lease_type').val('${param.lease_type}');
                    $('.monthly_type_name').val('${param.monthly_type_name}');
                    $('.start_date').val('${param.start_date}');
                    $('.end_date').val('${param.end_date}');
                    $('.create_time').val('${param.create_time}');
                    $('#isNotice').val('0');
                    $('#ownerInfoDiv').show();
                    renderView("ownerInfoDiv");
                    $('#lotNum').val('${param.lot_num}');
                    getMonthlyPreEndDate();
                    var parkId = $('#parkId').val();
                    var monthlyType = '${param.monthly_type}';
                    $('#ruleId').combobox('reload','${path.basePath}/ms/x/park_monthly_rule/findListData?isDisable=0&parkId='+parkId+'&monthlyType='+monthlyType)
                }
                if('${param.isView}' == 'true'){
                    $('#ruleId').combobox('reload','${path.basePath}/ms/x/park_monthly_rule/findListData');
                }

            },
            loadSuccess: function (info) {
            },
            onSave: function () {
                $('#isSync').val(0);
            },
            saveSucess: function () {
            },
            saveError: function () {
            },
            countAmount:function(_val){
                var startDate = dayjs($("#startDate").val());
                var endDate = dayjs($("#endDate").val());
                if(!startDate.isValid() || !endDate.isValid()){
                    return;
                }
                if(endDate.isBefore(startDate)){
                   $('#endDate').val("");
                   EalertE("结束时间在开始时间之前了奥");
                   return false;
               }
               reloadAmount();
            },

            reloadAmount:function(){
               /*
                 1 结束日期必须在开始日期之后
                 2 把结束和开始日期变成day.js对象
                 3 结束日期-  give_day_num天-give_month_mum月=新的结束日期
                 4 判断这个结束日期和开始日期比较大小。
                 5 获取月的数量 -- 赋值给月
                 6 月*单价*车位数量
                 7 把这个值赋值给金额
               */
               if($('#lotNum').val() > '${param.lot_num}'){
                    $('#lotNum').val('${param.lot_num}');
                    reloadAmount();
                    EalertE('您只拥有'+'${param.lot_num}'+'个车位哦');
                    return false;
               }
               var startDate = dayjs($("#startDate").val());
               var endDate = dayjs($("#endDate").val());
               var give_month_mum = $('#giveMonthMum').val();
               var give_day_num = $('#giveDayNum').val();
               var newEndDate = endDate.subtract(give_month_mum,'month').subtract(give_day_num,'day');
               if(newEndDate.isBefore(startDate)){
                  $('#leaseMonthNum').val(0);
                  $('#amount').val(0.00);
                  return false;
               }
                var monthNum = newEndDate.add(1, 'day').diff(startDate, 'month', true);
                $('#leaseMonthNum').val(isNaN(monthNum)?0:monthNum);
                var unitPrice = $('.unit_price').val();
                var lotNum = $('#lotNum').val();
                var amount = monthNum*unitPrice*lotNum;
                $('#amount').val(amount.toFixed(2));
            },
            //获取上一次月租续费的结束时间+1就是这一次续费的开始时间
            getMonthlyPreEndDate:function(){
                //拿到最后一条续费记录的结束时间
                $.get({url:'${path.basePath}ms/pay_inside_contract/findLastInfo/${param.inside_id}',success:function(record){
                    if(record.code != 200){
                        $('#startDate').val(getNowTime('yyyy-MM-dd'));
                        return;
                    }
                    if(record.data.endDate >= getNowTime('yyyy-MM-dd')){
                        //取结束时间
                        var endDate = addDate(record.data.endDate,1);
                        $('#startDate').val(dayjs(endDate).format('YYYY-MM-DD'));
                    }else{
                        //取当前时间
                        $('#startDate').val(getNowTime('yyyy-MM-dd'));
                    }
                },dataType:'json'});
            },
            //通过最少租赁月数和最大能租到哪一天得到默认的结束时间
            getDefaultEndDate:function(record){
                var lease_type_sett = JSON.parse(record.leaseTypeSett);
                for(leaseTypeId in lease_type_sett){
                     if(leaseTypeId == '${param.lease_type_id}'){
                         var unitPrice = lease_type_sett[leaseTypeId];
                         $('.unit_price').val(unitPrice);
                         break;
                     }
                }
                if($('.unit_price').val() == ''){
                    $('#ruleId').combobox('clear');
                    EalertE("所选收费规则"+$('.lease_type').val()+"的费用未配置哦");
                    return false;
                }
                 $('.max_date').val(record.maxDate);
                 $('.min_month').val(record.minMonth);
                 //只存在最少租赁月数
                if(record.minMonth && !record.maxDate){
                    var endDate = dayjs($('#startDate').val()).add(record.minMonth,'month').format('YYYY-MM-DD');
                    $('#endDate').val(endDate);
                    reloadAmount();
                    return;
                }
                //只存在最大能租到哪一天
                if(record.maxDate && !record.minMonth){
                    $('#endDate').val(record.maxDate);
                    reloadAmount();
                    return;
                }
                //最少租赁月数和最大能租到哪一天都存在
                if(record.maxDate && record.minMonth){
                    var endDate = dayjs($('#startDate').val()).add(record.minMonth,'month').subtract(1,'day');
                    $('#endDate').val(endDate.format('YYYY-MM-DD'));
                    reloadAmount();
                    return;
                }
                if($('#startDate').val() && $('#endDate').val()){
                    reloadAmount();
                }
            }
        }
    }
}
