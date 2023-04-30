function open_w(url) {
	var blocked = false;
	try {
		var newWin = window.open(url);
		if(newWin == null) {
			blocked = true;
		}
	} catch(ex) {
		block = true;
	}
	if(blocked) {
		alert("弹出窗口被阻止");
	}
}
/**
 * 判断是否是空
 * @param value
 */
function is_define(value)
{
	if (value == null || value == "" || value == "undefined" || value == undefined || value == "null" || value == "(null)" || value == 'NULL' || typeof (value) == 'undefined')
	{
		return false;
	}
	else
	{
		value = value + "";
		value = value.replace(/\s/g, "");
		if (value == "")
		{
			return false;
		}
		return true;
	}
}

/*获取页面传参*/
function GetRequest() {
	var url = location.search; //获取url中"?"符后的字串  
	var theRequest = new Object();
	if(url.indexOf("?") != -1) {
		var str = url.substr(1);
		strs = str.split("&");
		for(var i = 0; i < strs.length; i++) {
			theRequest[strs[i].split("=")[0]] = unescape(strs[i].split("=")[1]);
		}
	}
	return theRequest;
	console.log(JSON.parse(GetRequest().name).list)
}

/*阻止屏幕滑动*/
function bodyScroll(event){
	event.preventDefault();
}

function stopMove(status){
	if(status>0){
		document.body.addEventListener('touchmove',bodyScroll,false);
	}else{
		document.body.removeEventListener('touchmove',bodyScroll,false);
	}
}

/*
 * 自定义提示
 * txt 内容
 * t 消息时长
 * fun 确定按钮方法名
 */
function $toast(txt,t){
	stopMove(1);
	if(!is_define(txt)){
		return false;
	}
	if(!is_define(t)){
		t = 1500;
	}
	var html = '<div class="w10 h10 pstnf fadeIn top-0 zindex9" id="toast" style="top: 45%;">';
	html+= '<div class="w10 tx-c">';
	html+= '<div class="c-000-4 ftz-14 dsp-lb line-h-45 b-radius-15 pdl-15 pdr-15 t-wh" style="border-radius: 25px">'+txt+'</div>';
	html+= '</div>';
	html+= '</div>';
	$('body').append(html);
	setTimeout(function(){
		stopMove(0);
		$('#toast').remove();
	},t)
}

/*
 * 确定弹窗
 * title 标题
 * content 内容
 * btnL 左边按钮
 * btnR 右边按钮
 * fun 确定按钮方法名
 */
function $prompt(msg, callback){
	if(!is_define(msg.title)){
		msg.title = '提示消息';
	}
	this.html = '<div class="w10 h10 c-000-4 pstnf fadeIn top-0 zindex9" id="prompt">';
	html+= '<div class="w10 pstna" style="top: 35%;">';
	html+= '<div class="w75 box tx-c">';
	html+= '<div class="c-wh bor-1-f5f5f5 b-radius-15">';
	html+= '<div class="line-h-45 ftb">'+msg.title+'</div>';
	html+= '<div class="pdl-20 pdr-20 b-tb-f5f5f5">';
	html+= '<div class="ftz-13 umh-25 pdl-25 pdr-25 pdt-10 pdb-10">'+msg.content+'</div>';
	html+= '</div>';
	html+= '<div class="ov-h">';
	html+= '<div class="w5 line-h-45 fll t-149bfe b-r-f5f5f5" id="btnL">确定</div>';
	html+= '<div class="w5 line-h-45 fll" id="btnR">取消</div>';
	html+= '</div>';
	html+= '</div>';
	html+= '</div>';
	html+= '</div>';
	html+= '</div>';
	$('body').append(this.html);
	$('#btnL').click(function() {
		callback(1);
	})
	$('#btnR').click(function() {
		callback(2);
	})
}

/*关闭提示*/
function closePrompt(){
	$('#prompt').remove();
}

/*拨打电话*/
function callphone(tel){
	window.location.href = "tel:"+tel+"";
}
