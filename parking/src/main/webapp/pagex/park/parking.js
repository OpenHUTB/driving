var modelConfig= {title:'停车场',pkey:'id',type:'snow',orderBy:'update_time Desc',
    namespace:"parking",table:'t_park_parking',trans:true,extendsParam:'parent_park_id=${param.parent_park_id}',
    saveUrl:'${path.basePath}/ms/parking/save',
    joinColumns:JSON.stringify({park_name:'parkName'}),db:"park",dp:JSON.stringify({id:'parkIds'}),isMultiTenant:true};

var listPage={
    listFieldSett:function(){
        return [
            {name:'park_name',title:'停车场名称',width:'20%',align:'center'},
            {name:'space_count',title:'车位数',width:'10%',align:'center'},
            {name:'one_day_max_fee',title:'每天最高收费',width:'10%',align:'center'},
            {name:'address',title:'位置',width:'20%',align:'center'},
            {name:'park_type',title:'停车场类型',width:'10%',align:'center',trans:'book',key:'park_type',showField:'transMap.parkTypeName'},
            {name:'network_state',title:'网络状态',width:'10%',align:'center',trans:'book',key:'network_state',showField:'transMap.networkStateName'},
            {name:'create_user',title:'创建人',width:'10%',align:'center',trans:'user',showField:'transMap.create_userUserName'},
            {name:'is_sync',title:'是否已下发',width:'5%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.isSyncName'},
        ]},

    isColumnButton:function(){
        return  false;
    },
    filters:function(){
        return [
            {name:'park_name',type:'input',title:'停车场名称',filterType:'like'},
            {name:'address',type:'input',title:'位置',filterType:'like'},
        ];
    },
    buttons:function(){
        return [
            {title:'查看密钥',fun:'showSecret',permissionsCode:'parking:see',isRow:true},
            {title:'查看提前交费二维码',fun:'showQR',permissionsCode:'parking:see',isRow:true},
            {title:'查看微信包月二维码',fun:'showMontlyQR',permissionsCode:'parking:see',isRow:true},
            {title:'子车厂管理',fun:'childParking',permissionsCode:'parking:see',isRow:true,id:'childParkingBTN'},
            {title:'停车场区域',fun:'parkingRegion',permissionsCode:'park_region:see',isRow:true},
            {title:'特别放行原因',fun:'releaseReasons',permissionsCode:'park_special_pass_type:see',isRow:true},
            {title:'减免分类管理',fun:'reliefType',permissionsCode:'park_relief_type:see',isRow:true},
            {title:'月租户标签配置',fun:'tagConfig',permissionsCode:'pay_monthly_tag_config:see',isRow:true},
        ];
    },
    disableButtons:function(){
        return [];
    },
    otherFunctions:function(){
        return {
            showSecret:function(row){
                openDialog('${path.basePath}/ms/pagex/parking_add_update.jsp?showSecret=true&isView=true&id='
                    + row.id,
                    '查看停车场密钥');
            },
            showQR:function(row){
                openDialog('${path.basePath}/ms/pagex/parking_add_update.jsp?showQR=true&isView=true&id='
                    + row.id,
                    '查看二维码');
            },
            showMontlyQR:function(row){
                openDialog('${path.basePath}/ms/pagex/parking_add_update.jsp?showMontlyQR=true&isView=true&id='
                    + row.id,
                    '查看二维码');
            },

            childParking:function(row){
                var _openFrameMsg = {url:'${path.basePath}/ms/pagex/parking_list.jsp?parent_park_id=' + row.id,title:row.parkName + '的子车场管理'}
                top.postMessage(_openFrameMsg, '*');
            },
            onListPageReady:function(){
                if('${param.parent_park_id}'!=''&&'${param.parent_park_id}'!='0')
                {
                    $('#childParkingBTN').remove();
                }
            },
            parkingRegion:function(row){
                var _openFrameMsg = {url:'${path.basePath}/ms/pagex/park_region_list.jsp?park_id=' + row.id,title:row.parkName + '的区域'}
                top.postMessage(_openFrameMsg, '*');
            },
            releaseReasons:function(row){
                var _openFrameMsg = {url:'${path.basePath}/ms/pagex/park_special_pass_type_list.jsp?park_id=' + row.id,title:row.parkName + '放行原因'}
                top.postMessage(_openFrameMsg, '*');
            },
            reliefType:function(row){
                var _openFrameMsg = {url:'${path.basePath}/ms/pagex/park_relief_type_list.jsp?park_id=' + row.id,title:row.parkName + '减免分类管理'}
                top.postMessage(_openFrameMsg, '*');
            },
            tagConfig:function (row) {
                var _openFrameMsg = {url:'${path.basePath}/ms/pagex/pay_monthly_tag_config_list.jsp?park_id=' + row.id,title:row.parkName + '月租户标签管理'}
                top.postMessage(_openFrameMsg, '*');
            }
        }
    }
};
var add={
    formFields:function(){
        return [
            {type:'divStart',id:'parkingMainDiv'},
            {name:'park_name',title:'停车场名称',required:true,type:'input'},
            {name:'space_count',title:'车位总数',required:true,type:'input',dataType:'n1-5'},
            {name:'free_time',title:'免费时长(分钟)',required:true,type:'input',dataType:'n1-11'},
            {name:'exit_time',title:'提前缴费后出场时间(分钟)',required:true,type:'input',dataType:'n1-11'},
            {name:'black_list_remark',title:'黑名单提示语',required:true,type:'input'},
            {name:'one_day_max_fee',title:'每天最高收费',type:'input',dataType:'double2'},
            {name:'park_type',title:'车场类型',type:'book',code:'park_type',required:true},
            {name:'monthly_pre_days',title:'月租可往前选择多少天', required:true, type:'input',dataType:'n1-2'},
            {name:'monthly_after_days',title:'月租可往后选择多少天', required:true, type:'input',dataType:'n1-2'},
            {name:'monthly_notice_type',title:'月租到期提醒方式', required:true, type:'book',code:'monthly_notice_type',dftVal:'3'},
            {name:'monthly_notice_days',title:'提前多少天提醒', required:true, type:'input',dataType:'n1-2'},
            {name:'max_bind_plate_num',title:'最多绑定多少个车牌号', required:true, type:'input',dataType:'n1-2'},
            {name:'buffer_days',title:'月租到期缓冲天数',type:'input',dataType:'n1-2',required:true},
            {name:'one_24h_max_fee',title:'每24H最高收费',type:'input',dataType:'n1-2'},
            {name:'big_park_type',title:'场中场类型',type:'book',code:'big_park_type', required:true},
            {name:'spaces_census',title:'停车位统计',type:'book',code:'spaces_census', required:true,dftVal:'1'},
            {name:'max_monthly_lotnum',title:'在线包月最大限制车位数',type:'input',required:true,dataType:'n1-3'},
            {name:'is_road',title:'路边车场', required:true, type:'book',code:'yesOrNo',dftVal:'0',onSelect:'isRoadSelect',tinyint:true},
            {type:'divStart',id:'roadExtParamDiv',style:'display:none;'},
            {name:'fee_start_time',title:'路边开始收费时间',type:'time'},
            {name:'fee_end_time',title:'路边结束收费时间',type:'time'},
            {name:'is_hardware',title:'是否安装地磁',type:'book',code:'yesOrNo',dftVal:'0',tinyint:true},
            {type:'divEnd'},
            {name:'longitude,latitude,address,provinceid,cityid,areaid',type:'address'},
            {type:'divEnd'},
            {type:'divStart',id:'parkingSecretDvi',style:'display:none;'},
            {name:'secret',title:'密钥',type:'bigInput'},
            {name:'',title:'停车场id',type:'bigInput',class:'parking_id'},
            {type:'divEnd'},
            {type:'divStart',id:'qrCodeDiv',style:'display:none;width:90%;'},
            {type:'divEnd'},
            {name:'parent_park_id',type:'hide'},
            {name:'is_sync',type:'hide'}
        ];
    },
    otherFunctions:function(){
        return {
            ready:function(){
                if('${param.isAdd}'=='true')
                {
                    if('${param.parent_park_id}'!='')
                    {
                        $('#parentParkId').val('${param.parent_park_id}');
                    }
                    else
                    {
                        $('#parentParkId').val('0');
                    }
                    $('#blackListRemark').val('黑名单禁止入场');
                    $('#freeTime').val('30');
                    $('#exitTime').val('15');
                    $('#monthlyPreDays').val('0');
                    $('#monthlyAfterDays').val('0');
                    $('#monthlyNoticeDays').val('7');
                    $('#maxBindPlateNum').val('2');
                    $('#bufferDays').val('0');
                }
            },
            loadSuccess:function(info){
                $('.parking_id').val('${param.id}');
                if('${param.showSecret}'=='true')
                {
                    $('#parkingMainDiv').hide();
                    $('#parkingSecretDvi').show();
                }
                if('${param.showQR}'=='true' || '${param.showMontlyQR}'=='true')
                {
                    $('#parkingMainDiv').hide();
                    $("#qrCodeDiv").qrcode({
                        width:500,
                        height:500,
                        text:'${param.showQR}'=='true' ? '${path.basePath}/b/page-h5/advance_payment_u?parkId=' +info.id : '${path.basePath}/b/page-h5-month/index_u?parkId=' +info.id,
                    });
                    $('#qrCodeDiv').show();
                }
                isRoadSelect({wordbookCode:info.isRoad});
            },
            onSave:function(){
                if('${param.isAdd}'=='true')
                {
                    $('#secret').val(uuid());
                }
                $('#isSync').val(0);
            },
            isRoadSelect:function(record){
                if(record.wordbookCode=='1')
                {
                    $('#roadExtParamDiv').show();
                }
                else
                {
                    $('#roadExtParamDiv').hide();
                }
            },
            saveSucess:function(){
            },
            getConflictMsg:function(){
                return '停车场名称不可重复';
            },
            saveError:function(){

            },
        }
    }
}

//给前段用户的接口
// inF代表哪些字段需要返回给前段
// outF代表除了哪些字段要返回给前段
// where 后面支持哪些参数
var front ={
    apis:function(){return [
        {name:'info',type:'one',inF:'parkName',where:'id'},
        {name:'list',type:'list',inF:'parkName,id',jsonp:'true'},
        {name:'count',type:'count',where:'park_name'},
        {name:'pager',type:'pager',where:'park_name'},
    ]}};
