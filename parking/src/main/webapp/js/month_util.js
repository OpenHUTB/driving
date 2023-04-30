//设置cookie
function setCookie(name,value)
{
    var Days = 30;
    var exp = new Date();
    exp.setTime(exp.getTime() + Days*24*60*60*1000);
    console.log(escape (value) + ";expires=" + exp.toGMTString() + ';path=/');
    document.cookie = name + "="+ escape (value) + ";expires=" + exp.toGMTString() + ';path=/';
}
//读取cookies
function getCookie(name)
{
    var arr,reg=new RegExp("(^| )"+name+"=([^;]*)(;|$)");

    if(arr=document.cookie.match(reg))

        return unescape(arr[2]);
    else
        return null;
}

//删除cookies
function delCookie(name)
{
    var exp = new Date();
    exp.setTime(exp.getTime() - 1);
    var cval=getCookie(name);
    if(cval!=null)
        document.cookie= name + "="+cval+";expires="+exp.toGMTString();
}
//读取本地local
function getLocal(name) {
    return JSON.parse(localStorage.getItem(name))
}
//设置本地local
function setLocal(name, val) {
    localStorage.setItem(name, JSON.stringify(val))
}
//判断用户信息是否初始化
function initInfo(){
    if(!getLocal('init')){
        $.toast('请先填写基本信息','text');
        setTimeout('window.location.href="/b/page-h5-month/info_u"',1500);
    }
}
//判断停车场是否选择
function parkingIsNull(){
    if(!getCookie('parkId')) {
        $.toast('请先选择停车场','text');
        setTimeout('window.location.href="/b/page-h5-month/index_u"',1500);
    }
}
//检查是否绑定车牌
function checkPalte(){
    $.ajax({
        type: 'get',
        url: '/front/monthly/checkPalte',
        dataType: 'json',
        success: function(res){
            if(res.code == 200){
                if(!res.data){
                    $.toast('请先绑定车牌','text');
                    // keng  先给个提示，然后settimeout 2秒后再跳转，不然客户会以为怪怪的
                    setTimeout('window.location.href = "/b/page-h5-month/plate_list_u"',1500);
                }
            }
        }
    });
}
//检查是否有未支付订单  写到公共的代码中去，除了付款页面，其他的页面都要去判断
function checkUnpaidOrder(){
    $.ajax({
        type: 'get',
        url: '/front/monthly/getNoPayOnlinePayTempOrder',
        dataType: 'json',
        success: function(res){
            if(res.code = 200){
                if(res.data != null){
                    setLocal('orderParmas',res.data);
                    if(res.data.monthlyFeeStatus == 0){
                        window.location.href =  "/b/page-h5/order_pay";
                    }
                }
            }
        }
    });
}
//表单格式化成json
function serializeObject(form) {
    var o = {};
    var a = $(form).serializeArray();
    $.each(a, function() {
        if (o[this.name]) {
            if (!o[this.name].push) {
                o[this.name] = [o[this.name]];
            }
            o[this.name].push(this.value || '');
        } else {
            o[this.name] = this.value || '';
        }
    });
    return o;
};

//获取停车场信息
function getParkInfo(){
   var parkInfo;
   $.ajax({
        method: 'get',
        url: '/front/monthly/getParkInfo',
        async: false,
        success: function (res) {
            parkInfo = res;
        }
    })
    return parkInfo;
};

//创建订单
function addOnLinePayTempOrder(params){
     $.ajax({
         type: 'post',
         url: '/front/monthly/addOnLinePayTempOrder',
         data: params,
         dataType: 'json',
         success: function(res){
             if(res.code == 200){
                 setLocal('orderParmas',res.data);
                 window.location.href =  "/b/page-h5/order_pay";
             }else{
                 $.toast(res.message,'text')
             }
         }
     })
 }

 //检车车位已满
 function checkParkingLot(isRenew){
    $.ajax({
        type:'post',
        url:'/front/monthly/checkParkingLot',
        async: false,
        success: function(res){
            if(res.code == 200){
                if(!isRenew){
                    checkNewMonthly();
                }
            }else{
                $.toast('车位已满,暂时无法包月!','text');
                setTimeout('window.location.href="/b/page-h5-month/index_u"',1000);
            }
        }
    })
 }

 function checkNewMonthly(){
     $.ajax({
          type: 'get',
          url: '/front/monthly/getExecutingRecored',
          dataType: 'json',
          success: function(res){
              if(res.code == 200){
                  if(res.data){
                      $.toast('您必须在当前包月结束后方可进行新的包月，包月结束日期为'+res.data);
                      setTimeout(function () { window.location.href = '/b/page-h5-month/index_u' },1000);
                  }
              }
          }
      });
  }
