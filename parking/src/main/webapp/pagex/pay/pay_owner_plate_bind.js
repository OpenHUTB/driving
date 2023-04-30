var modelConfig= {title:'车牌车主管理',pkey:'id',type:'snow',
    orderBy:'create_time desc',
    namespace:"pay_owner_plate_bind",table:'pay_owner_plate_bind',trans:true};
var listPage={
    listFieldSett:function(){
        return [
            {name:'plate_number',title:'车牌号',width:'25%',align:'center'},
            {name:'name',title:'车主姓名',width:'25%',align:'center'},
            {name:'mobile',title:'车主电话',width:'25%',align:'center'},
            {name:'img',title:'照片车辆',width:'24%',align:'center'},
            {name:'data_source_type',title:'信息来源',width:'25%',align:'center',trans: 'book',key: 'data_source_type',showField: 'transMap.data_source_type'},
            {name:'collector_id',title:'上报人',width:'24%',align:'center',trans:'pagex',key:'ucenter_toll_collector',showField:'transMap.userName'},
        ]},
    isColumnButton: function () {
        return true;
    },
    filters:function(){
        return [
            {name: 'plate_number', type: 'input', title: '车牌号', filterType: 'like'},
            {name: 'plate_number', type: 'input', title: '手机号', filterType: 'like'},
        ];
    },
    buttons:function(){
        return [];
    },
    disableButtons:function(){
        return ["add", "update", "delete","export"];
    },
    otherFunctions:function(){
        return {
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
            loadSuccess: function () {

            },
            onSave: function () {

            },
            saveSucess: function () {

            },
            saveError: function () {

            },
            reloadPort: function () {


            }
        }
    }
};