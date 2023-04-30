var modelConfig = {
    title: '结余时长计费',
    pkey: 'id',
    type: 'snow',
    orderBy: 'update_time Desc',
    namespace: "pay_temp_order_fee_balance",
    table: 't_pay_temp_order_fee_balance',
    extendsParam: 'temp_order_id=${param.temp_order_id}'
};
var listPage = {
    listFieldSett: function () {
        return [
            {name: 'price', title: '单价', width: '33%', align: 'center'},
            {name: 'minutes', title: '结余时长(分钟)', width: '33%', align: 'center'},
            {name: 'amount', title: '总金额', width: '33%', align: 'center'},
        ]
    },
    isColumnButton: function () {
        return true;
    },
    filters: function () {
        return [];
    },
    buttons: function () {
        return [];
    },
    disableButtons: function () {
        return ["view", "add", "update", "delete"];
    },
    otherFunctions: function () {
        return {
            onListPageReady: function () {
                $('.searchBTN').hide();
            },
        }
    }
};
var add = {
    formFields: function () {
        return [];
    },
    otherFunctions: function () {
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

            },
        }
    }
}
