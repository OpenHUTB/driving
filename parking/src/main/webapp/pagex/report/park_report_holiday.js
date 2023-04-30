var modelConfig = {
    title: '节假日',pkey:'id',type:'snow',table:'t_park_report_holiday',orderBy:'create_time Desc',
    exjs:'${path.staticPath}/js/My97DatePicker/WdatePicker.js',
    namespace: "park_report_holiday",trans:true
};
var listPage = {
    listFieldSett: function () {
        return [
            {name: 'holiday_name', title: '名称', width: '14.2%', align: 'center'},
            {name: 'holiday_date_start', title: '开始时间', width: '14.2%', align: 'center'},
            {name: 'holiday_date_end', title: '结束时间', width: '14.2%', align: 'center'},
            {name: 'type', title: '类型', width: '14.2%',trans:'book',key:'holiday_vacations',showField:'transMap.typeName', align: 'center'},
            {name: 'create_user', title: '创建人', width: '14.2%', align: 'center',trans:'user',showField:'transMap.create_userUserName'},
            {name: 'create_time', title: '创建时间', width: '14.2%', align: 'center'},
            {name: 'update_user', title: '修改人', width: '14.2%', align: 'center',showField:'transMap.create_userUserName'},
            {name: 'update_time', title: '修改时间', width: '14.2%', align: 'center'},

        ]
    },
    isColumnButton: function () {
        return false;
    },
    filters: function () {
        return [
            {name:'holiday_name',title:'名称',type:'input',filterType:'like'},
            {name:'type',title:'类型',type:'book' ,code: 'holiday_vacations', showAll: true},
            {name: 'holiday_date_start', type: 'date', title: '节假日时间',formart:'yyyy',filterType:'like'},
        ];
    },
    buttons: function () {
        return [

        ];
    },
    disableButtons: function () {
        //return ["view","add","update","delete","export"];
        return [];
    },
    otherFunctions: function () {
        return {

        }
    }
};

var add = {
    formFields: function () {
        return [
            {name: 'holiday_name', title: '名称' ,type:'input', required: true},
            {name: 'type', title: '类型', required: true, type: 'book', code: 'holiday_vacations'},
            {name: 'holiday_date_start',type: 'date',required: true,onpicked:'startDataCheck()', title: '节假日开始时间' ,formart:'yyyy-MM-dd'},
            {name: 'holiday_date_end',type: 'date', title: '节假日结束时间',onpicked:'endDataCheck()' ,formart:'yyyy-MM-dd', required: true},

        ];
    },
    otherFunctions: function () {
        return {
            ready: function () {
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
            endDataCheck: function () {
                var holiday_date_start = $("#holidayDateStart").val();
                var holiday_date_end = $("#holidayDateEnd").val();
                if(holiday_date_start!='' && holiday_date_end !=''){
                    if(holiday_date_end<holiday_date_start){
                        $('#holidayDateEnd').val("");
                        EalertE("节假日结束时间必须大于开始时间");
                        return false;
                    }
                }

            },
            startDataCheck: function () {
                var holiday_date_start = $("#holidayDateStart").val();
                var holiday_date_end = $("#holidayDateEnd").val();
                if(holiday_date_end!='' && holiday_date_start!=''){
                    if(holiday_date_end<holiday_date_start){
                        $('#holidayDateStart').val("");
                        EalertE("节假日开始时间必须小于结束时间");
                        return false;
                    }
                }

            }

        }
    }
};











