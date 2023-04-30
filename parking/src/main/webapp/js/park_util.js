// 将分钟数量转换为小时和分钟字符串
function toHourMinute(minutes){
    var _day = parseInt(minutes/(24*60));
    var _hours = Math.floor((minutes%(24*60))/60);
    var _minute = (minutes%60);
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