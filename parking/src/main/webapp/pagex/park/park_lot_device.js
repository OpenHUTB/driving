var modelConfig= {title:'地磁设备',pkey:'id',type:'snow',
    orderBy:'update_time Desc',
    namespace:"park_lot_device",table:'t_park_lot_device',trans:true, db:"park",dp:JSON.stringify({park_id:'parkIds'})};
var listPage={
    listFieldSett:function(){
	  return [
        {name:'service_code',title:'服务code',width:'10%',align:'center'},
        {name:'sn',title:'设备编号',width:'10%',align:'center'},
        {name:'park_id',title:'停车场名称',width:'10%',trans:'pagex',key:'parking',showField:'transMap.parkName',align:'center'},
        {name:'lot_id', title: '泊位号', width: '10%', align: 'center', trans:'simple', target: 'com.xhb.park.bean.ParkRegionLot',field:'lotNo',alias:'lotNo', showField: 'transMap.lotNoLotNo'},
        {name:'type',title:'分配状态',width:'10%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.typeName'},
        {name:'is_on_line',title:'是否在线',width:'10%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.isOnLineName'},
        {name:'create_user',title:'创建人',width:'15%',align:'center',trans:'sysUser',showField:'transMap.create_userUserName'},
        {name:'create_time',title:'创建时间',width:'20%',align:'center'},
    ]},
    isColumnButton:function(){
	  return  true;
  },
  filters:function(){
      return [
          {name:'park_id',type:'select',url:'${path.basePath}/ms/x/parking/findListData',
              valuefield:'id',textfield:'parkName',title:'停车场',showAll:true},
          {name:'type',title:'是否分配',type:'book',code:'yesOrNo',showAll:true},
          {name:'is_on_line',title:'是否在线',type:'book',code:'yesOrNo',showAll:true},
          {name:'sn',title:'设备编号',type:'input',filterType:'like'},
	 ];
  },
  buttons:function(){
      return [
          {title:'分配',fun:'boundParkingSpace',permissionsCode:'park_region:see',isRow:true},
          {title:'解绑',fun:'nuBoundParkingSpace',permissionsCode:'park_region:see',isRow:true}
      ];
  },
  disableButtons:function(){
	    return ["delete","update","view"];
  },
  otherFunctions:function(){
      return {
          boundParkingSpace:function(row){
              if(row.type==1){
                  openDialog('${path.basePath}/b/page-ms-park/park_lot_bound?id=' + row.id
                      + '&sn=' + row.sn
                      + '&parkId=' + row.parkId
                      +'&lotId=' + row.lotId, '分配车位');
              }else {
                  openDialog('${path.basePath}/b/page-ms-park/park_lot_bound?id=' + row.id
                      + '&sn=' + row.sn, '分配车位');
              }
          },
          nuBoundParkingSpace:function(row){
              if(row.type==1){
                  $.get({url:'${path.basePath}/ms/lotDevice/nuBoundParkingSpace?sn=' + row.sn,
                      dataType:'json',
                      success:function(leaseTypes){
                          Ealert("操作成功");
                          reload();
                      },
                      error:function (res){
                          EalertE("操作失败",res.message);
                      }
                  });
              }else{
                  EalertE('只有分配才会有解绑噢');
              }
          },
	  }
  }
};
var add={
	formFields:function(){
	     return [
	        {name:'service_code',title:'服务code',type:'input'},
            {name:'sn',title:'设备编号',type:'input',required:true},
            {name:'type',title:'分配状态',type:'hide'},
            {name:'is_on_line',title:'是否在线',type:'hide'},
		 ];
	},
    otherFunctions:function(){
      return {
	    ready:function(){
	    },
	    loadSuccess:function(info){

	    },
	    onSave:function(){
            $('#type').val(0);
            $('#isOnLine').val(0);
        },
		saveSucess:function(){
	    },
		saveError:function(){

	    },
	  }
   }
}
