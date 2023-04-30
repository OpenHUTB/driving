var carCode = '';
$(function() {
	var winH = $(window).height(); //浏览器当前窗口可视区域高度
	$('body').height(winH + 'px');
	hideKeyboard();
})

function inputCarNum(obj) {
	$(obj).addClass('dspn');
	$('#carNumBox').removeClass('dspn');
	showKeyboard();
	moveFocus();
}

//隐藏键盘
function hideKeyboard() {
	$('#keyBoard').slideUp();
}

//显示键盘
function showKeyboard() {
	$('#keyBoard').slideDown();
	if(carCode.length>0){
		$('#first1').removeClass('dspn');
		$('#first').addClass('dspn');
		$('.sure').addClass('dspn');
		$('.sure1').removeClass('dspn');
		$('#alphabetKeyboardDel').addClass('dspn');
		$('#provinceKeyboard').addClass('dspn');
		$('#alphabetKeyboard').removeClass('dspn');
	}
}
//第一格
function chooseOne(obj) {
	var text1 = $(obj).text();
	insertText(text1);
	$('#provinceKeyboard').addClass('dspn');
	carCode += text1;
	if(text1 == 'W') {
		insertText('J');
		carCode += 'J';
		$('#wjKeyboard').removeClass('dspn');
	} else {
		$('#alphabetKeyboard').removeClass('dspn');
	}
	moveFocus();
}

//第2格以后
function chooseTwo(obj) {
	var text1 = $(obj).text();
	insertText(text1);
	carCode += text1;
	$('#first1').removeClass('dspn');
	$('#first').addClass('dspn');
	var carCodeLength = carCode.length;
	if(carCode=='WJ'){
		$('#wjKeyboard').removeClass('dspn');
		$('#alphabetKeyboard').addClass('dspn');
	}else{
		$('#wjKeyboard').addClass('dspn');
		if(carCodeLength > 1 && carCodeLength < 6) {
			$('.one').addClass('dspn');
			$('.two').removeClass('dspn');
			$('.sure1').addClass('dspn');
			$('.sure').removeClass('dspn');
			$('#alphabetKeyboardDel').addClass('dspn');
			$('#alphabetKeyboard').removeClass('dspn');
		} else if(carCodeLength == 6) {
			$('#alphabetKeyboard').removeClass('dspn');
			$('#alphabetKeyboardDel').addClass('dspn');
			$('.three').removeClass('dspn');
			$('.one').addClass('dspn');
			$('.two').addClass('dspn');
			$('.sure1').addClass('dspn');
			$('.sure').removeClass('dspn');
		} else if(carCodeLength == 7) {
			$('.sure').addClass('dspn');
			$('.sure1').removeClass('dspn');
			if(text1 == '港' || text1 == '澳' || text1 == '学') {
				$('#alphabetKeyboardDel').removeClass('dspn');
				$('#alphabetKeyboard').addClass('dspn');
				$('#cursor').addClass('dspn');
				return false;
			}else{
				$('#alphabetKeyboardDel').addClass('dspn');
				$('#alphabetKeyboard').removeClass('dspn');
			}
		}else if(carCodeLength == 8) {
			$('#cursor').addClass('dspn');
			$('#alphabetKeyboardDel').removeClass('dspn');
			$('#alphabetKeyboard').addClass('dspn');
			$('#new').removeClass('dspn').val(text1);
			insertText(text1);
			$('#new').val(text1);
			$('#new1').addClass('dspn');
		}
	}
	$('#wjKeyboardDel').addClass('dspn');
	moveFocus();
}

//删除
function del() {
	var txt = carCode.slice(0, -1);
	var inputBox = $('#carNumBox').find('input');
	$(inputBox[txt.length]).val('');
	carCode = txt;
	var carCodeLength = carCode.length;
	$('#new').addClass('dspn');
	$('#new1').removeClass('dspn');
	if(carCode=='WJ'){
		$('#wjKeyboard').removeClass('dspn');
		$('#alphabetKeyboard').addClass('dspn');
	}else{
		$('#provinceKeyboard').addClass('dspn');
		$('#alphabetKeyboard').removeClass('dspn');
		if(carCodeLength > 1 && carCodeLength < 6) {
			$('#alphabetKeyboard').removeClass('dspn');
			$('#alphabetKeyboardDel').addClass('dspn');
			$('.one').addClass('dspn');
			$('.two').removeClass('dspn');
			$('.three').addClass('dspn');
			$('.sure1').addClass('dspn');
			$('.sure').removeClass('dspn');
		} else if(carCodeLength == 6) {
			$('#alphabetKeyboard').removeClass('dspn');
			$('#alphabetKeyboardDel').addClass('dspn');
			$('.three').removeClass('dspn');
			$('.one').addClass('dspn');
			$('.two').addClass('dspn');
			$('.sure1').addClass('dspn');
			$('.sure').removeClass('dspn');
		} else if(carCodeLength > 6) {
			$('.sure').addClass('dspn');
			$('.sure1').removeClass('dspn');
			$('#alphabetKeyboardDel').addClass('dspn');
			$('#alphabetKeyboard').removeClass('dspn');
		} else if(carCodeLength < 1) {
			$('#provinceKeyboard').removeClass('dspn');
			$('#wjKeyboard').addClass('dspn');
			$('#alphabetKeyboard').addClass('dspn');
			$('#wjKeyboardDel').addClass('dspn');
			$('#alphabetKeyboardDel').addClass('dspn');
		}
		if(carCodeLength>1){
			$('#first1').removeClass('dspn');
			$('#first').addClass('dspn');
		}else{
			$('#first1').addClass('dspn');
			$('#first').removeClass('dspn');
		}
	}
	$('#cursor').removeClass('dspn');
	moveFocus();
	if(carCode == 'W') {
		$('#wjKeyboard').addClass('dspn');
		$('#alphabetKeyboard').addClass('dspn');
		$('#alphabetKeyboardDel').addClass('dspn');
		$('#wjKeyboardDel').removeClass('dspn');
	}
}

function moveFocus() {
	var inputBox = $('#carNumBox').find('input');
	for(var i = 0; i < inputBox.length; i++) {
		if(!$(inputBox[i]).val()) {
			if(i>1){
				$('#cursor1').addClass('dspn');
				$('#cursor').removeClass('dspn');
				var left = i*12.5+'%';
				$('#cursor').css('left',left);
			}else{
				$('#cursor').addClass('dspn');
				$('#cursor1').removeClass('dspn');
				var left = i*11+'%';
				$('#cursor1').css('left',left);
			}
			return false;
		} else {
			if(carCode.length > 8) {
				$toast('最多只能输入8位',1500);
				carCode = carCode.slice(0, 8);
				return false;
			}
		}
	}
}

function insertText(t) {
	var inputBox = $('#carNumBox').find('input');
	var carCodeLength = carCode.length;
	$(inputBox[carCodeLength]).val(t);
}

//确定
function sure() {
	hideKeyboard();
	$('#cursor').addClass('dspn');
}