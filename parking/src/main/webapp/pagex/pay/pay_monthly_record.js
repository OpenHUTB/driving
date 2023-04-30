var modelConfig= {title:'月租户',pkey:'id',type:'snow',
    orderBy:'update_time Desc',
    namespace:"pay_monthly_record",table:'t_pay_monthly_record',trans:true,db:"park",dp:JSON.stringify({park_id:'parkIds'}),isMultiTenant:true};

var listPage={
    listFieldSett:function(){
        return [
            {name:'cus_name',title:'客户名称',width:'10%',align:'center'},
            {name:'park_id',title:'停车场名称',width:'15%',trans:'pagex',key:'parking',showField:'transMap.parkName',align:'center'},
            {name:'cus_mobile',title:'联系方式',width:'10%',align:'center',dataType:'m'},
            {name:'plate_number',title:'车牌号',width:'10%',align:'center'},
            {name:'start_date',title:'开始时间',width:'15%',align:'center',formart:'time2Day'},
            {name:'end_date',title:'结束日期',width:'15%',align:'center',formart:'time2Day'},
            {name:'create_user',title:'创建人',width:'9%',align:'center',trans:'sysUser',showField:'transMap.create_userUserName'},
            {name:'is_sync',title:'是否已下发',width:'5%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.is_syncName'},
        ]},
    isColumnButton:function(){
        return  true;
    },
    filters:function(){
        return [
            {name:'park_id',type:'select',url:'${path.basePath}/ms/x/parking/findListData',valuefield:'id',textfield:'parkName',title:'停车场',showAll:true},
            {name:'cus_name',title:'客户名称',type:'input',filterType:'like'},
            {name:'plate_number',title:'车牌号',type:'input',filterType:'like'},
        ];
    },
    buttons:function(){
        return [];
    },
    disableButtons:function(){
        return [];
    },
    otherFunctions:function(){
        return {

        }
    }
};
var add={
    formFields:function(){
        return [
            {name:'cus_name',title:'客户名称',type:'input',required:true},
            {name:'park_id',type:'select',url:'${path.basePath}/ms/x/parking/findListData',
                             valuefield:'id',textfield:'parkName',title:'停车场',required:true,onSelect:'reloadLeaseTypeSett'},
            {name:'cus_mobile',title:'联系方式',type:'input',required:true,dataType:'m'},
            {name:'car_type',title:'车辆类别',required:true,type:'book',code:'car_type',onSelect:'reloadLeaseTypeSett'},
            {name:'plate_number',title:'车牌号',type:'input',required:true,dataType:"plate_number|plate_number_new"},
            {name:'start_date',title:'开始日期',type:'date',placeholder:'请选择开始日期',formart: 'yyyy-MM-dd',required:true},
            {name:'monthly_type',title:'租赁类型',type:'book',code:'monthly_type',onSelect:'reloadDate',required:true},
            {name:'end_date',title:'结束日期',type:'date',placeholder:'请选择结束日期',formart: 'yyyy-MM-dd',required:true},
            {name:'lease_type_id',title:'租户类型',type:'select',url:'${path.basePath}/ms/x/parking_lease_type/findListData?isDisable=0',
                valuefield:'id',textfield:'leaseName',onSelect:'reloadLeaseTypeSett',required:true},
            {name:'fee_amonth',title:'费用(元)',type:'input',required:true,dataType:'double2'},
            {name:'is_sync',title:'是否同步',type:'hide'},
            {name:'monthly_rule_id',title:'月租户类型id',type:'hide'},

        ];
    },
    otherFunctions:function(){
        return {
            ready:function(){
            },
            loadSuccess:function(info){
                $('#startDate').val(info.startDate.substring(0,10));
                $('#endDate').val(info.endDate.substring(0,10));
            },
            onSave:function(){
                $('#isSync').val(0);
                var startDate = $('#startDate').val();
                if(startDate && startDate.length == 10){
                    $('#startDate').val(startDate+' 00:00:00');
                }
                var endDate = $('#endDate').val();
                if(endDate && endDate.length == 10){
                    $('#endDate').val(endDate+' 23:59:59');
                }
            },
            saveSucess:function(){
            },
            saveError:function(){

            },
            reloadDate:function(record){
                reloadLeaseTypeSett();
                if(!$('#startDate').val())
                {
                    return;
                }
                var startDate = convertDateFromString($('#startDate').val());
                var bookCode = new Number(record.wordbookCode);
                //代表月份
                if(bookCode < 3){
                    startDate.setMonth(startDate.getMonth()+1);
                }else if(bookCode < 6){//季度
                    startDate.setMonth(startDate.getMonth()+3);
                }else if(bookCode < 9){//年租
                    startDate.setMonth(startDate.getMonth()+12);
                }else if(bookCode == 9){
                    startDate.setYear(startDate.getFullYear()+1);
                }
                startDate.setDate(startDate.getDate()-1);
                $('#endDate').val(dateFmt(startDate,'yyyy-MM-dd'));
            },
            reCaclFeeAmount:function(){
                var _leaseTypeId = $('#leaseTypeId').combobox('getValue');
                if(_leaseTypeId)
                {
                    $('#feeAmonth').val(overallVariable.lease_type_sett[_leaseTypeId]);
                }
            },
            reloadLeaseTypeSett:function(){//重新加载价格配置并且计算价格
                if($('#monthlyType').combobox('getValue') && $('#carType').combobox('getValue') &&  $('#parkId').combobox('getValue'))
                {
                    $.get({
                        url:'${path.basePath}/ms/x/park_monthly_rule/findListData?isDisable=0&parkId=' +
                            $('#parkId').combobox('getValue') +'&monthlyType=' + $('#monthlyType').combobox('getValue') + '&carType=' + $('#carType').combobox('getValue'),
                        success:function(result)
                        {
                            if(result.length>0)
                            {
                                overallVariable.lease_type_sett=str2json(result[0].leaseTypeSett);
                                reCaclFeeAmount();
                                $('#monthlyRuleId').val(result[0].id);
                            }
                            else
                            {
                                overallVariable.lease_type_sett={};
                                $('#feeAmonth').val('');
                                EalertE('没有找到对应的月租户收费规则，请先配置月租户收费规则');
                            }
                        },
                        dataType:'json'
                    })
                }
            }
        }
    }
}
