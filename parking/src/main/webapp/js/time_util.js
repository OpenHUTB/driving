// 将分钟数量转换为小时和分钟字符串
function toHourMinute(value){
    if(value){
        var _day = parseInt(value/(24*60));
        var _hours = Math.floor((value%(24*60))/60);
        var _minute = (value%60);
        if(_day==0)
        {
            if(_hours==0)
            {
                return _minute + '分';
            }
            return _hours+'小时'+_minute + '分';
        }
        return _day + '天' + _hours + '小时' + _minute + '分';
    }
    return "";
}

// 将"yyyyMMddHHmmss"时间格式转换为"yyyy-MM-dd HH:mm:ss"
function timeFormart(value) {
    if(value){
        var year = value.substr(0,4);
        var month = value.substr(4,2);
        var day = value.substr(6,2);
        var hour = value.substr(8,2);
        var minute = value.substr(10,2);
        var second = value.substr(12,2);
        return year + "-" + month + "-" + day + " " + hour + ":" + minute + ":" + second;
    }
    return "";
}