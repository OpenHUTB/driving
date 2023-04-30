var modelConfig= {title:'出入口',pkey:'id',type:'snow',orderBy:'update_time Desc',
    namespace:"parking_port",table:'t_park_parking_port',trans:true,
    joinColumns:JSON.stringify({port_name:'portName'}),db:"park",dp:JSON.stringify({park_id:'parkIds'}),isMultiTenant:true};

var listPage={
    listFieldSett:function(){
	  return [
		  {name:'port_name',title:'出入口名称',width:'10%',align:'center'},
		  {name:'park_id',title:'停车场名称',width:'10%',trans:'pagex',key:'parking',showField:'transMap.parkName',align:'center'},
          {name:'port_fun_type',title:'使用功能类别',width:'10%',align:'center',key:'port_fun_type',trans:'book',showField:'transMap.port_fun_typeName'},
          {name:'is_disable',title:'是否禁用',width:'10%',formart:'formatRowColor',align:'center',trans:'book',key:'is_disable',showField:'transMap.is_disableName'},
          {name:'is_main',title:'是否为主闸机',width:'10%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.is_mainName'},
          {name:'is_only_monthly',title:'是否仅月租',width:'10%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.is_only_monthlyName'},
          {name:'is_mast_fee',title:'是否收费',width:'10%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.is_mast_feeName'},
          {name: 'create_time', title: '创建时间', width: '14%', align: 'center'},
          {name:'create_user',title:'创建人',width:'10%',align:'center',trans:'sysUser',showField:'transMap.create_userUserName'},
          {name:'is_sync',title:'是否已下发',width:'5%',align:'center',trans:'book',key:'yesOrNo',showField:'transMap.is_syncName'},
  ]},
  isColumnButton:function(){
	  return  false;
  },
  filters:function(){
      return [
          {name:'park_id',type:'select',url:'${path.basePath}/ms/x/parking/findListData',
              valuefield:'id',textfield:'parkName',title:'停车场',showAll:true},
          {name:'port_name',type:'input',title:'出入口名称',filterType:'like'},
      ];
  }, 
  buttons:function(){
      return [
          {title:'出口交费二维码',fun:'showQR',permissionsCode:'parking_port:see',isRow:true},
          {title:'无牌车入场二维码',fun:'showQRNoPlateNumberCome',permissionsCode:'parking_port:see',isRow:true},
          {title:'无牌车出场二维码',fun:'showQRNoPlateNumberOut',permissionsCode:'parking_port:see',isRow:true},
          ];
  },
  disableButtons:function(){
	    return [];
  },
  otherFunctions:function(){
      return {
          showQR:function(row){
              if(row.portFunType==2)
              {
                  openDialog('${path.basePath}/ms/pagex/parking_port_add_update.jsp?showQR=true&isView=true&id='
                      + row.id,
                      '查看二维码');
              }
              else
              {
                  EalertE('只有出口才会有二维码噢');
              }
          },
          showQRNoPlateNumberCome:function(row){
               if(row.portFunType==1){
                    openDialog('${path.basePath}/ms/pagex/parking_port_add_update.jsp?showQR=true&isView=true&notPlatNumberCome=true&id='
                                          + row.id,
                                          '查看无牌车生成二维码');
               }else{
                    EalertE('只有入口才会有无牌车入场二维码噢');
               }
          },

          showQRNoPlateNumberOut:function(row){
                 if(row.portFunType==2){
                      openDialog('${path.basePath}/ms/pagex/parking_port_add_update.jsp?showQR=true&isView=true&notPlatNumberOut=true&id='
                                            + row.id,
                                            '查看无牌车交费二维码');
                 }else{
                      EalertE('只有出口才会有无牌车出场二维码噢');
                 }
            }

	  }		
  }
};

var add={ 
	formFields:function(){
	     return [
             {type:'divStart',id:'mainDiv'},
             {name:'park_id',type:'select',url:'${path.basePath}/ms/x/parking/findListData',
                 valuefield:'id',textfield:'parkName',title:'停车场',required:true,onSelect:'reloadSelect'},
             {name:'port_name',title:'名称',required:true,type:'input'},
             /*{name:'port_type',title:'出入口类型',type:'book',code:'port_type'},*/
             {name:'port_ip',title:'摄像头ip',dataType:'ipv4|ipv6',type:'input',required:true},
             /*{name:'camera_port',title:'摄像头端口',dataType:'n1-10',type:'input'},*/
             {name:'port_fun_type',title:'功能类别',required:true,type:'book',code:'port_fun_type'},
             {name:'is_main',title:'是否为主闸机',required:true,type:'book',code:'yesOrNo'},
             {name:'is_only_monthly',title:'是否仅月租',type:'book',code:'yesOrNo'},
             {name:'is_mast_fee',title:'是否收费',type:'book',code:'yesOrNo',required:true},
             {name:'is_disable',title:'是否禁用',type:'switch',dft:false},
             {name:'description',title:'描述',type:'text'},
             {name:'real_location',title:'位置描述',type:'text'},
             {name:'img',title:'图片',type:'up',placeholder:'请上传出入口图片'},
             {name:'is_sync',title:'是否下发',type:'hide'},
             {type:'divEnd'},
             {type:'divStart',id:'qrCodeDiv',style:'display:none;width:90%;'},
             {type:'divEnd'},
		 ];
	},
    otherFunctions:function(){
      return {
	     ready:function(){

	    },
	    loadSuccess:function(info){
            if('${param.showQR}'=='true')
            {
                $('#mainDiv').hide();
                $('#qrCodeDiv').show();
                var qrUrl = '${path.basePath}/b/page-h5/pay_last_carout_u?parkId=' +info.parkId + '&portId=' + info.id;
                //无牌车入场二维码
                if('${param.notPlatNumberCome}'=='true'){
                    qrUrl='${path.basePath}/front/tempPlate/carCome_u?parkId=' +info.parkId + '&portId=' + info.id;
                }
                //无牌车出场二维码
                if('${param.notPlatNumberOut}'=='true'){
                    qrUrl='${path.basePath}/front/tempPlate/carOut_pay_u?parkId=' +info.parkId + '&portId=' + info.id;
                }
                $("#qrCodeDiv").qrcode({
                    width:500,
                    height:500,
                    text:qrUrl,
                });
            }
            var tagUrl = '${path.basePath}/ms/x/pay_monthly_tag_config/findListData?park_id=' + info.parkId;
            $('#allowEnterTagIds_select').combobox('reload',tagUrl);
            $('#fullAllowEnterTagIds_select').combobox('reload',tagUrl);
            $('#allowEnterInpeakTagIds_select').combobox('reload',tagUrl);
            var regionUrl = '${path.basePath}/ms/x/park_region/findListData?park_id=' + info.parkId;
            $('#insideSpaceId').combobox('reload',regionUrl);
            $('#outsideSpaceId').combobox('reload',regionUrl);

	    },
	    onSave:function(){
            $('#isSync').val(0);
	    },
		saveSucess:function(){
	    },
		saveError:function(){
        },
        reloadSelect:function (record) {
            var tagUrl = '${path.basePath}/ms/x/pay_monthly_tag_config/findListData?park_id=' + record.id;
            $('#allowEnterTagIds_select').combobox('clear');
            $('#allowEnterTagIds_select').combobox('reload',tagUrl);
            $('#fullAllowEnterTagIds_select').combobox('clear');
            $('#fullAllowEnterTagIds_select').combobox('reload',tagUrl);
            $('#allowEnterInpeakTagIds_select').combobox('clear');
            $('#allowEnterInpeakTagIds_select').combobox('reload',tagUrl);
            var regionUrl = '${path.basePath}/ms/x/park_region/findListData?park_id=' + record.id;
            $('#insideSpaceId').combobox('clear');
            $('#outsideSpaceId').combobox('reload',regionUrl);
            $('#outsideSpaceId').combobox('clear');
            $('#insideSpaceId').combobox('reload',regionUrl);
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
        {name:'list',type:'list',inF:'portName,id',jsonp:'false',where:'parkId,portFunType'},
 ]}};
