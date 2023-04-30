var modelConfig = {
    title: '收费人员', pkey: 'collector_id', type: 'snow', orderBy: 'update_time Desc',
    namespace: "ucenter_toll_collector", table: 't_ucenter_toll_collector',trans: true,  exjs: '${path.staticPath}/js/jQuery.md5.js',
    joinColumns:JSON.stringify({name:'userName'}),isMultiTenant:true,db:"park",dp:JSON.stringify({park_id:'parkIds'})};
var listPage = {
    listFieldSett: function () {
        return [
            {name: 'name', title: '姓名', width: '10%', align: 'center'},
            {name: 'login_name', title: '登录名', width: '14%', align: 'center'},
            /*{name: 'org_id', title: '所属部门', width: '10%', align: 'center',trans:'sysOrganizationInfo',showField:'transMap.org_idOrganizationName'},*/
            {name: 'mobile', title: '手机号', width: '15%', align: 'center'},
            {name: 'create_time', title: '创建时间', width: '15%', align: 'center'},
            {name:'create_user',title:'创建人',width:'10%',align:'center',trans:'user',showField:'transMap.create_userUserName'},
            {name: 'update_time', title: '更新时间', width: '15%', align: 'center'},
            {name:'update_user',title:'修改人',width:'10%',align:'center',trans:'user',showField:'transMap.update_userUserName'},
            {name:'is_sync',title:'是否已下发',width:'10%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.is_syncName',tinyint:true},

        ]
    },
    isColumnButton: function () {
        return false;
    },
    filters: function () {
        return [
            {name: 'name', type: 'input', title: '姓名', filterType: 'like'},
            {
                name: 'park_id', type: 'select', url: '${path.basePath}/ms/x/parking/findListData',
                valuefield: 'id', textfield: 'parkName', title: '停车场',showAll:true
            }
        ];
    },
    buttons: function () {
        return [];
    },
    disableButtons: function () {
        return [];
    },
    otherFunctions: function () {
        return {}
    }
};

var add = {
    formFields: function () {
        return [
            {name: 'name', title: '姓名', required: true, type: 'input'},
            {name: 'login_name', title: '登录名', required: true, type: 'input'},
            {name:'is_road',title:'是否管理路边',required:true,tinyint:true,type:'book',code:'yesOrNo',onSelect:'isRoadSelect'},
            {type:'divStart',id:'notRoad',style:'display:none'},
            {name:'park_id',type:'select',url:'${path.basePath}/ms/parking/getParkParkingList?isRoad=0',
                valuefield:'parkId',textfield:'parkName',title:'停车场'},
            {type:'divEnd'},
            {type:'divStart',id:'road',style:'display:none'},
            {name:'park_ids',type:'select',url:'${path.basePath}/ms/parking/getParkParkingList?isRoad=1',
                valuefield:'parkId',textfield:'parkName',title:'停车场', multiple:true},
            {type:'divEnd'},
            {name: 'mobile', title: '手机号', required: true, type: 'input',dataType:'m'},
            {name: '',class:'passwordClass', title: '密码', type: 'hide'},
            {name: 'is_sync', title: '是否同步', type: 'hide',tinyint:true,},
            {name:'password',title:'密码',type:'password',required:true}

        ];
    },
    otherFunctions: function () {
        return {
            ready: function () {
                //新增默认非路边
                if('${param.isAdd}'=='true'){
                    isRoadChange('0');
                }else{
                    $('#loginName').attr("readonly","readonly")
                }
            },
            isRoadSelect:function(record){
                isRoadChange(record.wordbookCode);
            },
            isRoadChange:function(isRoad){
                $('#isRoad').combobox("setValue",isRoad);
                //非路边，单选
                if(isRoad == '0'){
                    //单选车位
                    $('#notRoad').show();
                    $('#road').hide();
                    $('#parkIds_select').combobox("setValues",[]);
                }else{
                    //路边多选
                    $('#road').show();
                    $('#notRoad').hide();
                    $('#parkId').combobox("setValue",'');
                }
            },
            loadSuccess: function (info) {
                $('.passwordClass').val($('#password').val());
                isRoadChange(info.isRoad);
            },
            onSave: function () {
                $('#isSync').val(0);
                //未加密的密码需要进行加密
                if($('#isRoad').combobox("getValue")=='1'){
                    if($('#parkIds_select').combobox("getValues").length == 0){
                        EalertE('请选择停车场');
                        return false;
                    }
                }else{
                    if(!$('#parkId').combobox("getValue")){
                        EalertE('请选择停车场');
                        return false;
                    }
                }
                var oldPassword = $('.passwordClass').val();
                if (oldPassword != $('#password').val() && $('#password').val().length !=32) {
                    $('#password').val($.md5($('#password').val()));
                }
            },
            saveSucess: function () {

            },
            saveError: function () {

            }
        }
    }
};












