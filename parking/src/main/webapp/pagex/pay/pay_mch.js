var modelConfig= {title:'威富通商户管理',pkey:'id',type:'snow',orderBy:'update_time Desc',
    namespace:"pay_mch",table:'t_pay_mch',trans:true,joinColumns:JSON.stringify({mch_name:'mchName'})};

var listPage={
    listFieldSett:function(){
        return [
              {name:'mch_name',title:'商户名称',width:'10%',align:'center'},
              {name:'mch_type',title:'商户类型',width:'10%',align:'center',trans:'book',key:'mch_type',showField:'transMap.mch_typeName'},
              {name:'mch_secret',title:'商户密钥',width:'13%',align:'center'},
              {name:'sign_type',title:'加密方式',width:'10%',align:'center',trans:'book',key:'sign_type',showField:'transMap.sign_typeName'},
              {name:'public_key',title:'公钥',width:'12%',align:'center'},
              {name:'private_key',title:'密钥',width:'12%',align:'center'},
              {name:'mp_app_id',title:'公众号的appid',width:'12%',align:'center'},
              {name:'create_user',title:'创建人',width:'10%',align:'center',trans:'user',showField:'transMap.create_userUserName'},
              {name:'create_time',title:'创建时间',width:'10%',align:'center'},
        ]
    },
    isColumnButton:function(){
      return  false;
    },
    filters:function(){
      return [
          {name:'park_ids',type:'select',url:'${path.basePath}/ms/parking/getParkList',
              valuefield:'parkId',textfield:'parkName',title:'停车场',showAll:true,filterType:'like',width:'500'},
          {name:'mch_type',type:'book',title:'商户类型',code:'mch_type',showAll:true},
          {name:'mch_name',type:'input',title:'商户名称',filterType:'like'},
      ];
    },
      buttons:function(){
          return [

          ];
      },
  disableButtons:function(){
	    return [];
  },
  otherFunctions:function(){
      return {}
  }
};

var add={
	formFields:function(){
	     return [
             {name:'park_ids',type:'select',url:'${path.basePath}/ms/parking/getParkList',
                 valuefield:'parkId',textfield:'parkName',title:'停车场',multiple:true},
             {name:'mch_type',title:'商户类型',required:true,type:'book',code:'mch_type'},
             {name:'mch_name',title:'商户名称',type:'input',required:true},
             {name:'swiftpass_mch_id',title:'威富通商户id',type:'input',required:true},
             {name:'mch_secret',title:'威富通商户密钥',type:'input',required:true},
             {name:'public_key',title:'公钥',type:'input'},
             {name:'private_key',title:'密钥',type:'input'},
             {name:'sign_type',title:'加密方式',type:'book',code:'sign_type',required:true},
             {name:'mp_app_id',title:'公众号的appid',type:'input'},
             {name:'payee_type',title:'收款方式',type:'book',code:'payee_type',required:true},
             {name:'group_code',title:'集团编码',type:'input'},
             {name:'passageway_type',title:'支付方式',type:'book',code:'passageway_type',required:true},
         ];
	},
    otherFunctions:function(){
      return {
	     ready:function(){

	    },
	    loadSuccess:function(info){
	    },
	    onSave:function(){
	    },
		saveSucess:function(){
	    },
		saveError:function(){

	    },
	  }
   }
}
