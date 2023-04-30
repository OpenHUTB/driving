var modelConfig = {
    title: '商家管理',
    pkey: 'id',
    type: 'snow',
    orderBy: 'update_time Desc',
    exjs: '${path.staticPath}/js/jQuery.md5.js,${path.staticPath}/js/math.js',
    joinColumns: JSON.stringify({merchant_name: 'merchantName'}),
    namespace: "business_merchant",
    table: 't_business_merchant',
    trans: true,
    isMultiTenant: true,
    db: "park",
    dp: JSON.stringify({park_id: 'parkIds'}),
    saveUrl: '${path.basePath}/ms/business_merchant/add',
};
var listPage = {
    listFieldSett: function () {
        return [
            {
                name: 'park_id',
                title: '所属停车场',
                width: '15%',
                trans: 'pagex',
                key: 'parking',
                showField: 'transMap.parkName',
                align: 'center'
            },
            {name: 'merchant_name', title: '商家名称', width: '16%', align: 'center'},
            {name: 'merchant_address', title: '商家地址', width: '13%', align: 'center'},
            {name: 'login_name', title: '登录账号', width: '12%', align: 'center'},
            {name: 'contact_name', title: '联系人名称', width: '11%', align: 'center'},
            {name: 'contact_mobile', title: '联系电话', width: '10%', align: 'center'},
            {name: 'remark', title: '商家描述', width: '11%', align: 'center'},
            {name: 'balance', title: '余额', width: '11%', align: 'center'},
            {name: 'discount', title: '折扣', width: '11%', align: 'center', formart: 'showDiscount'}
        ]
    },
    isColumnButton: function () {
        return true;
    },
    filters: function () {
        return [
            {
                name: 'park_id',
                type: 'select',
                url: '${path.basePath}/ms/parking/getParkList',
                valuefield: 'parkId',
                textfield: 'parkName',
                title: '停车场',
                showAll: true
            },
            {name: 'merchant_name', type: 'input', title: '商家名称', filterType: 'like'},
        ];
    },
    buttons: function () {
        return [
            {title: '充值', fun: 'recharge', permissionsCode: 'business_balance_recharge_log:update', isRow: true},
            {title: '充值记录', fun: 'rechargeRecord', permissionsCode: 'business_balance_recharge_log:see', isRow: true},
            {title: '余额变动记录', fun: 'changeRecord', permissionsCode: 'business_balance_change_log:see', isRow: true},
        ];
    },
    disableButtons: function () {
        return ["delete"];
    },
    otherFunctions: function () {
        return {
            showDiscount: function (_val, row, index) {
                if (_val) {
                    if (_val == 100) {
                        return "无折扣"
                    }
                    return math.divide(_val, 10) + "折";
                }
            },
            recharge: function (record) {
                record.roomNum = record.roomNum == null ? "" : record.roomNum;
                openDialog('${path.basePath}/ms/pagex/business_balance_recharge_log_add_update.jsp?isAdd=true&park_id=' + record.parkId + '&merchant_id=' + record.id + '&merchant_name=' + record.merchantName + '&contact_mobile=' + record.contactMobile + '&merchant_address=' + record.merchantAddress + '&balance=' + record.balance, '商户余额充值');
            },
            rechargeRecord: function (record) {
                //充值记录
                var _openFrameMsg = {
                    url: '${path.basePath}/ms/pagex/business_balance_recharge_log_list.jsp?park_id=' + record.parkId + '&merchant_id=' + record.id,
                    title: record.merchantName + '的充值记录'
                };
                top.postMessage(_openFrameMsg, '*');
            },
            changeRecord: function (record) {
                //余额变更记录
                var _openFrameMsg = {
                    url: '${path.basePath}/ms/pagex/business_balance_change_log_list.jsp?park_id=' + record.parkId + '&merchant_id=' + record.id,
                    title: record.merchantName + '的余额变更记录'
                };
                top.postMessage(_openFrameMsg, '*');
            }
        }
    }
};
var add = {
    formFields: function () {
        return [
            {
                name: 'merchant_name',
                title: '商家名称',
                required: true,
                type: 'input',
                dataType: '/^.{2,20}$/',
                placeholder: '至少输入2个字'
            },
            {
                name: 'merchant_address',
                title: '商家地址',
                type: 'input',
                dataType: '/^.{1,100}$/',
                placeholder: '商家地址长度不能超过100个字符'
            },
            {name: 'login_name', title: '登录账号', required: true, type: 'input'},
            {name: 'password', title: '登录密码', required: true, type: 'password'},
            {
                name: 'park_id',
                title: '所属停车场',
                type: 'select',
                url: '${path.basePath}/ms/parking/getParkList',
                valuefield: 'parkId',
                textfield: 'parkName',
                required: true
            },
            {name: 'contact_name', title: '联系人名称', type: 'input', dataType: 's2-20', placeholder: '至少输入2个字'},
            {name: 'contact_mobile', title: '联系电话', type: 'input', dataType: 'tel|tel_p'},
            {
                name: 'discount',
                title: '折扣',
                type: 'input',
                placeholder: '85代表8.5折,100为无折扣',
                dataType: 'n1-3'
            },
            {name: 'remark', title: '商家描述', type: 'text'},
            {name: 'logo', title: '商家Logo', type: 'up'},
            {name: '', class: 'passwordClass', title: '密码', type: 'hide'},
            {name: 'balance', type: 'hide'},
        ];
    },
    otherFunctions: function () {
        return {
            ready: function () {
                if ('${param.isAdd}' == 'true') {
                    $('#balance').val(0);
                } else {
                    $('#merchantName').attr("readonly","readonly");
                    $('#loginName').attr("readonly","readonly");
                    $('#parkId').combobox('readonly',true);
                }
            },
            loadSuccess: function (info) {
                $('.passwordClass').val($('#password').val());
            },
            onSave: function () {
                if ($('#discount').val() > 100) {
                    $('#discount').val(100);
                }
                //未加密的密码需要进行加密
                var oldPassword = $('.passwordClass').val();
                if (oldPassword != $('#password').val()  && $('#password').val().length !=32) {
                    $('#password').val($.md5($('#password').val()));
                }
            },
            getConflictMsg: function () {
                return '登录账号不可重复';
            },
            saveSucess: function () {
            },
            saveError: function () {
            },
        }
    }
}
