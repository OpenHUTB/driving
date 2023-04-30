function H5SClusterHttpGet(url)
{
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.open("GET", url, false );
    xmlHttp.send( null );
    return xmlHttp.responseText;
}

function H5SClusterGetConf(conf)
{
    var strStatusUrl =  conf.protocol + '//' + conf.host + conf.rootpath +
                'api/v1/cluster/GetClusterStatus';
    console.log(strStatusUrl);        
    var strStatus = H5SClusterHttpGet(strStatusUrl);
    console.log(strStatus);
    var strStatusJson = JSON.parse(strStatus);
    if (strStatusJson["bEnable"] == true)
    {
        console.log("Cluster enable");
        var strProtocol = "http";
        if (conf.protocol == "https:")
        {
            strProtocol = "https";
        }
        var strAddrUrl =  conf.protocol + '//' + conf.host + conf.rootpath +
                    'api/v1/cluster/GetServiceAddr?service=' + strProtocol + '&token=' + conf.token;
        var strAddr = H5SClusterHttpGet(strAddrUrl);
        console.log(strAddr);
        var strAddrJson = JSON.parse(strAddr);
        conf.host = strAddrJson["strAddr"] + ':' + strAddrJson["nPort"];
        console.log("Cluster get play host", conf.host);
    }
}