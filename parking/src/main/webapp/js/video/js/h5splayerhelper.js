/** 
    Check platform and OS
	(platform.name); // 'Safari'
	(platform.version); // '11.1'
	(platform.product); // 'iPad'
	(platform.manufacturer); // 'Apple'
	(platform.layout); // 'WebKit'
	(platform.os.family); // 'iOS'
	(platform.description);// 'Safari 11.1 on Apple iPad (iOS 11.0)'
 
*/
function H5siOS() {
    var browserName = platform.os.family;
    if (/ios/i.test(browserName)) {
        return true;
    }
    return false;
}

function H5sChromeBrowser() {
    var browserName = platform.name;
    if (/chrome/i.test(browserName)) {
        return true;
    }
    return false;
}

function H5sEdgeBrowser() {
    var browserName = platform.name;
    if (/edge/i.test(browserName)) {
        return true;
    }
    return false;
}

function H5sSafariBrowser() {
    var browserName = platform.name;
    console.log(browserName);
    if (/safari/i.test(browserName)) {
        return true;
    }
    return false;
}

function H5sAndriodPlatform() {
    var browserName = platform.os.family;
    if (/android/i.test(browserName)) {
        return true;
    }
    return false;
}

function H5sPlayerCreate(conf) {
    var player;
    if (H5siOS()) {
        player = new H5sPlayerRTC(conf);
    } else {
        player = new H5sPlayerWS(conf);
    }
    return player;
}