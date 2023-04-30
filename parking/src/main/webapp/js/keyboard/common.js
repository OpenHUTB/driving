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

function alert(message){
    if ($("#dialogalert").length == 0) {
        $("body").append('<div id="dialogalert"></div>');
        $("#dialogalert").dialog({
            title:"提示",
            dialogClass:"dialog-alert",
            autoOpen: false,
            show: {
                effect: "shake",
                duration: 500
            },
            hide: {
                effect: "explode",
                duration: 500
            },
            modal: true,
            resizable:false,
            overlay: {
                opacity: 0.5,
                background: "black"
            },
            buttons: {
                "我知道了": function(){
                    $(this).dialog("close");
                }
            }
        });
    }
    $("#dialogalert").html(message);
    $("#dialogalert").dialog("open");
}
