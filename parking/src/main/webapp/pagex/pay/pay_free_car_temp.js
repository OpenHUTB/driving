var modelConfig= {title:'临时免费车',pkey:'id',type:'snow',
    orderBy:'update_time Desc',
    namespace:"pay_free_car_temp",table:'t_pay_free_car_temp',trans:true,db:"park",dp:JSON.stringify({park_id:'parkIds'}),isMultiTenant:true};
var listPage={
    listFieldSett:function(){
        return [
            {name:'plate_number',title:'车牌号',width:'20%',align:'center'},
            {name:'park_id',title:'停车场名称',width:'20%',trans:'pagex',key:'parking',showField:'transMap.parkName',align:'center'},
            {name:'start_time',title:'开始时间',width:'20%',align:'center',formart:'time2Day'},
            {name:'end_time',title:'结束时间',width:'20%',align:'center',formart:'time2Day'},
            {name:'remark',title:'备注',width:'19%',align:'center'},
        ]},
    isColumnButton:function(){
        return  true;
    },
    filters:function(){
        return [
            {name:'plate_number',type:'input',title:'车牌号',filterType:'like'},
            {name:'park_id',type:'select',url:'${path.basePath}/ms/x/parking/findListData',valuefield:'id',textfield:'parkName',title:'停车场',showAll:true}
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
            {name:'plate_number',type:'input',title:'车牌号',required:true,dataType:'plate_number|plate_number_new'},
            {name:'start_time',type:'date',title:'开始时间',formart: 'yyyy-MM-dd',required:true},
            {name:'end_time',type:'date',title:'结束时间',formart: 'yyyy-MM-dd',required:true},
            {name:'park_id',type:'select',url:'${path.basePath}/ms/x/parking/findListData',
                valuefield:'id',textfield:'parkName',title:'停车场名称',required:true},
            {name:'radio',type:'input',title:'优惠百分比',required:true,dataType:'n1-3',errormsg:'优惠百分比请输入1-100的数字'},
            {name:'remark',type:'text',title:'备注',required:true},
            {name: 'is_sync',type:'hide'}
        ];
    },
    otherFunctions:function(){
        return {
            ready:function(){
                $('#radio').val(100);
            },
            loadSuccess:function(info){
                $('#startTime').val(info.startTime.substring(0,10));
                $('#endTime').val(info.endTime.substring(0,10));
            },
            onSave:function(){
                $('#isSync').val(0);
                var startTime = $('#startTime').val();
                if(startTime && startTime.length==10){
                    $('#startTime').val(startTime+' 00:00:00');
                }
                var endTime = $('#endTime').val();
                if(endTime&& endTime.length==10){
                    $('#endTime').val(endTime+' 23:59:59');
                }
                if($('#radio').val()&&new Number($('#radio').val())>100)
                {
                    EalertE('优惠百分比最高是100');
                    return false;
                }
            },
            saveSucess:function(){
            },
            saveError:function(){

            }
        }
    }
};
