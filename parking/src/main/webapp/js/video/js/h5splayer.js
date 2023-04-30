function H5sPlayerWS(t) {
    var s;
    this.sourceBuffer,
    this.buffer = [],
    this.t,
    this.s,
    this.i,
    this.o,
    this.h,
    this.l = 0,
    this.u = 0,
    this.S = 0,
    this.v = !1,
    this.k = !1,
    this.p = !1,
    this.H,
    this.P = t,
    console.log("Websocket Conf:", t),
    this.W = t.videoid,
    this.C = t.device,
    this.I = t.token,
    void 0 === this.W ? (this.m = t.videodom, console.log(t.token, "use dom directly")) : (this.m = document.getElementById(this.W), console.log(t.token, "use videoid")),
    this.s = this.m,
    void 0 === this.C ? (s = this.P.protocol + "//" + this.P.host + this.P.rootpath + "api/v1/GetImage?token=" + this.I + "&session=" + this.P.session, console.log(t.token, "connect src")) : (s = this.P.protocol + "//" + this.P.host + this.P.rootpath + "api/v1/GetImage?token=" + this.I + "&device=" + this.C + "&session=" + this.P.session, console.log(t.token, "connect device")),
    this.m.setAttribute("poster", s)
}
function H5sPlayerHls(t) {
    this.i,
    this.h,
    this.P = t,
    this.W = t.videoid,
    this.I = t.token,
    this.A,
    this.R = t.hlsver,
    void 0 === this.W ? (this.m = t.videodom, console.log(t.token, "use dom directly")) : (this.m = document.getElementById(this.W), console.log(t.token, "use videoid")),
    this.M = this.m,
    this.M.type = "application/x-mpegURL",
    this.T = 0,
    this.O = 0;
    var s = this.P.protocol + "//" + this.P.host + this.P.rootpath + "/api/v1/GetImage?token=" + this.I + "&session=" + this.P.session;
    this.m.setAttribute("poster", s)
}
function H5sPlayerRTC(t) {
    var s;
    this.i,
    this.o,
    this.h,
    this.l = 0,
    this.u = 0,
    this.S = 0,
    this.v = !1,
    this.k = !1,
    this.P = t,
    this.W = t.videoid,
    this.C = t.device,
    this.I = t.token,
    void 0 === this.W ? (this.m = t.videodom, console.log(t.token, "use dom directly")) : (this.m = document.getElementById(this.W), console.log(t.token, "use videoid")),
    this.s = this.m,
    this.J = null,
    this.N = {
        optional: [{
            DtlsSrtpKeyAgreement: !0
        }]
    },
    this.g = {
        mandatory: {
            offerToReceiveAudio: !0,
            offerToReceiveVideo: !0
        }
    },
    this.B = {
        L: []
    },
    this.D = [],
    void 0 === this.C ? (s = this.P.protocol + "//" + this.P.host + this.P.rootpath + "api/v1/GetImage?token=" + this.I + "&session=" + this.P.session, console.log("connect src", t.token)) : (s = this.P.protocol + "//" + this.P.host + this.P.rootpath + "api/v1/GetImage?token=" + this.I + "&device=" + this.C + "&session=" + this.P.session, console.log("connect device", t.device, " ", t.token)),
    this.m.setAttribute("poster", s)
}
function createRTCSessionDescription(t) {
    return console.log("createRTCSessionDescription "),
    new RTCSessionDescription(t)
}
function H5sPlayerAudio(t) {
    this.buffer = [],
    this.i,
    this.v = !1,
    this.k = !1,
    this.P = t,
    console.log("Aduio Player Conf:", t),
    this.I = t.token,
    this.G = new AudioContext
}
function H5sPlayerAudBack(t) {
    this.buffer = [],
    this.i,
    this.v = !1,
    this.k = !1,
    this.P = t,
    this.U = 0,
    console.log("Aduio Back Conf:", t),
    this.I = t.token,
    this.G = new AudioContext
}
function float32ToInt16(t) {
    for (l = t.length, buf = new Int16Array(l); l--;) buf[l] = 32767 * Math.min(1, t[l]);
    return buf
}
H5sPlayerWS.prototype._ = function() { ! 0 === this.v && (console.log("Reconnect..."), this.K(this.I), this.v = !1)
},
H5sPlayerWS.prototype.V = function(t) {
    var s;
    console.log("H5SWebSocketClient");
    try {
        "http:" == this.P.protocol && (s = "undefined" != typeof MozWebSocket ? new MozWebSocket("ws://" + this.P.host + t) : new WebSocket("ws://" + this.P.host + t)),
        "https:" == this.P.protocol && (console.log(this.P.host), s = "undefined" != typeof MozWebSocket ? new MozWebSocket("wss://" + this.P.host + t) : new WebSocket("wss://" + this.P.host + t)),
        console.log(this.P.host)
    } catch(t) {
        return void alert("error")
    }
    return s
},
H5sPlayerWS.prototype.j = function() {
    if (null !== this.sourceBuffer && void 0 !== this.sourceBuffer) {
        if (0 !== this.buffer.length && !this.sourceBuffer.updating) try {
            var t = this.buffer.shift(),
            s = new Uint8Array(t);
            this.sourceBuffer.appendBuffer(s)
        } catch(t) {
            console.log(t)
        }
    } else console.log(this.sourceBuffer, "is null or undefined")
},
H5sPlayerWS.prototype.q = function() {
    try {
        var t = {
            cmd: "H5_KEEPALIVE",
            nSpeed: "1.0",
            nTime: "0"
        };
        this.i.send(JSON.stringify(t))
    } catch(t) {
        console.log(t)
    }
},
H5sPlayerWS.prototype.F = function(t) {
    if (!0 !== this.k) return ! 1 === this.p ? (this.H = String.fromCharCode.apply(null, new Uint8Array(t.data)), this.X(this), void(this.p = !0)) : (this.buffer.push(t.data), void this.j())
},
H5sPlayerWS.prototype.X = function(t) {
    try {
        window.MediaSource = window.MediaSource || window.WebKitMediaSource,
        window.MediaSource || console.log("MediaSource API is not available");
        var s = 'video/mp4; codecs="avc1.42E01E, mp4a.40.2"';
        "MediaSource" in window && MediaSource.isTypeSupported(s) ? console.log("MIME type or codec: ", s) : console.log("Unsupported MIME type or codec: ", s),
        t.t = new window.MediaSource,
        t.s.autoplay = !0,
        console.log(t.W);
        t.s.src = window.URL.createObjectURL(t.t),
        t.s.play(),
        t.t.addEventListener("sourceopen", t.Y.bind(t), !1)
    } catch(t) {
        console.log(t)
    }
},
H5sPlayerWS.prototype.Y = function() {
    console.log("Add SourceBuffer"),
    this.sourceBuffer = this.t.addSourceBuffer(this.H),
    this.t.duration = 1 / 0,
    this.t.removeEventListener("sourceopen", this.Y, !1),
    this.sourceBuffer.addEventListener("updateend", this.j.bind(this), !1)
},
H5sPlayerWS.prototype.K = function(t) {
    this.s.autoplay = !0;
    var s = "api/v1/h5swsapi";
    s = void 0 === this.C ? this.P.rootpath + s + "?token=" + t + "&session=" + this.P.session: this.P.rootpath + s + "?token=" + t + "&device=" + this.C + "&session=" + this.P.session,
    console.log(s),
    this.i = this.V(s),
    console.log("setupWebSocket", this.i),
    this.i.binaryType = "arraybuffer",
    (this.i.Z = this).i.onmessage = this.F.bind(this),
    this.i.onopen = function() {
        console.log("wsSocket.onopen", this.Z),
        this.Z.o = setInterval(this.Z.$.bind(this.Z), 1e4),
        this.Z.h = setInterval(this.Z.q.bind(this.Z), 1e3)
    },
    this.i.onclose = function() {
        console.log("wsSocket.onclose", this.Z),
        !0 === this.Z.k ? console.log("wsSocket.onclose disconnect") : this.Z.v = !0,
        this.Z.tt(this.Z),
        this.Z.st(this.Z),
        this.Z.H = "",
        this.Z.p = !1
    }
},
H5sPlayerWS.prototype.tt = function(t) {
    console.log("Cleanup Source Buffer", t);
    try {
        t.sourceBuffer.removeEventListener("updateend", t.j, !1),
        t.sourceBuffer.abort(),
        document.documentMode || /Edge/.test(navigator.userAgent) ? console.log("IE or EDGE!") : t.t.removeSourceBuffer(t.sourceBuffer),
        t.sourceBuffer = null,
        t.t = null,
        t.buffer = []
    } catch(t) {
        console.log(t)
    }
},
H5sPlayerWS.prototype.st = function(t) {
    console.log("CleanupWebSocket", t),
    clearInterval(t.h),
    clearInterval(t.o),
    t.l = 0,
    t.u = 0,
    t.S = 0
},
H5sPlayerWS.prototype.$ = function() { ! 0 === this.k && (console.log("CheckSourceBuffer has been disconnect", this), clearInterval(this.h), clearInterval(this.o), clearInterval(this.et));
    try {
        if (console.log("CheckSourceBuffer", this), this.sourceBuffer.buffered.length <= 0) {
            if (this.l++, 8 < this.l) return console.log("CheckSourceBuffer Close 1"),
            void this.i.close()
        } else {
            this.l = 0;
            this.sourceBuffer.buffered.start(0);
            var t = this.sourceBuffer.buffered.end(0),
            s = t - this.s.currentTime;
            if (5 < s || s < 0) return console.log("CheckSourceBuffer Close 2", s),
            void this.i.close();
            if (t == this.u) {
                if (this.S++, 3 < this.S) return console.log("CheckSourceBuffer Close 3"),
                void this.i.close()
            } else this.S = 0;
            this.u = t
        }
    } catch(t) {
        console.log(t)
    }
},
H5sPlayerWS.prototype.connect = function() {
    this.K(this.I),
    this.et = setInterval(this._.bind(this), 3e3)
},
H5sPlayerWS.prototype.disconnect = function() {
    console.log("disconnect", this),
    this.k = !0,
    clearInterval(this.et),
    null != this.i && (this.i.close(), this.i = null),
    console.log("disconnect", this)
},
H5sPlayerWS.prototype.pause = function() {
    try {
        var t = {
            cmd: "H5_PAUSE",
            nSpeed: "1.0",
            nTime: "0"
        };
        this.i.send(JSON.stringify(t))
    } catch(t) {
        console.log(t)
    }
},
H5sPlayerWS.prototype.resume = function() {
    try {
        var t = {
            cmd: "H5_RESUME",
            nSpeed: "1.0",
            nTime: "0"
        };
        this.i.send(JSON.stringify(t))
    } catch(t) {
        console.log(t)
    }
},
H5sPlayerWS.prototype.seek = function(t) {
    try {
        var s = {
            cmd: "H5_SEEK",
            nSpeed: "1.0"
        };
        s.nTime = t,
        this.i.send(JSON.stringify(s))
    } catch(t) {
        console.log(t)
    }
},
H5sPlayerWS.prototype.speed = function(t) {
    try {
        var s = {
            cmd: "H5_SPEED"
        };
        s.nSpeed = t,
        s.nTime = 0,
        this.i.send(JSON.stringify(s))
    } catch(t) {
        console.log(t)
    }
},
H5sPlayerHls.prototype.V = function(t) {
    var s;
    console.log("H5SWebSocketClient");
    try {
        "http:" == this.P.protocol && (s = "undefined" != typeof MozWebSocket ? new MozWebSocket("ws://" + this.P.host + t) : new WebSocket("ws://" + this.P.host + t)),
        "https:" == this.P.protocol && (console.log(this.P.host), s = "undefined" != typeof MozWebSocket ? new MozWebSocket("wss://" + this.P.host + t) : new WebSocket("wss://" + this.P.host + t)),
        console.log(this.P.host)
    } catch(t) {
        return void alert("error")
    }
    return s
},
H5sPlayerHls.prototype.q = function() {
    try {
        var t = {
            type: "keepalive"
        };
        this.i.send(JSON.stringify(t))
    } catch(t) {
        console.log(t)
    }
},
H5sPlayerHls.prototype.F = function(t) {
    console.log("HLS received ", t.data)
},
H5sPlayerHls.prototype.K = function(t) {
    var s = "api/v1/h5swscmnapi";
    s = this.P.rootpath + s + "?token=" + t + "&session=" + this.P.session,
    console.log(s),
    this.i = this.V(s),
    console.log("setupWebSocket", this.i),
    this.i.binaryType = "arraybuffer",
    (this.i.Z = this).i.onmessage = this.F.bind(this),
    this.i.onopen = function() {
        console.log("wsSocket.onopen", this.Z),
        this.Z.h = setInterval(this.Z.q.bind(this.Z), 1e3)
    },
    this.i.onclose = function() {
        console.log("wsSocket.onclose", this.Z),
        this.Z.st(this.Z)
    }
},
H5sPlayerHls.prototype.st = function(t) {
    console.log("H5sPlayerHls CleanupWebSocket", t),
    clearInterval(t.h)
},
H5sPlayerHls.prototype.it = function() {
    console.log("HLS video.ended", this.M.ended),
    console.log("HLS video.currentTime", this.M.currentTime);
    var t = this.M.currentTime,
    s = t - this.T;
    console.log("HLS diff", s),
    0 === s && this.O++,
    this.T = t,
    3 < this.O && (null != this.i && (this.i.close(), this.i = null), this.K(this.I), console.log("HLS reconnect"), this.M.src = "", this.T = 0, this.O = 0, this.M.src = this.P.protocol + "//" + this.P.host + this.P.rootpath + "hls/" + this.R + "/" + this.I + "/hls.m3u8", this.M.play())
},
H5sPlayerHls.prototype.connect = function() {
    this.K(this.I),
    this.T = 0,
    this.O = 0,
    this.M.onended = function(t) {
        console.log("The End")
    },
    this.M.onpause = function(t) {
        console.log("Pause")
    },
    this.M.onplaying = function(t) {
        console.log("Playing")
    },
    this.M.onseeking = function(t) {
        console.log("seeking")
    },
    this.M.onvolumechange = function(t) {
        console.log("volumechange")
    },
    this.M.src = this.P.protocol + "//" + this.P.host + this.P.rootpath + "hls/" + this.R + "/" + this.I + "/hls.m3u8",
    this.M.play(),
    this.A = setInterval(this.it.bind(this), 3e3)
},
H5sPlayerHls.prototype.disconnect = function() {
    clearInterval(this.A),
    this.T = 0,
    this.O = 0,
    null != this.i && (this.i.close(), this.i = null),
    console.log("disconnect", this)
},
H5sPlayerRTC.prototype._ = function() { ! 0 === this.v && (console.log("Reconnect..."), this.K(this.I), this.v = !1)
},
H5sPlayerRTC.prototype.V = function(t) {
    var s;
    console.log("H5SWebSocketClient");
    try {
        "http:" == this.P.protocol && (s = "undefined" != typeof MozWebSocket ? new MozWebSocket("ws://" + this.P.host + t) : new WebSocket("ws://" + this.P.host + t)),
        "https:" == this.P.protocol && (console.log(this.P.host), s = "undefined" != typeof MozWebSocket ? new MozWebSocket("wss://" + this.P.host + t) : new WebSocket("wss://" + this.P.host + t)),
        console.log(this.P.host)
    } catch(t) {
        return void alert("error")
    }
    return s
},
H5sPlayerRTC.prototype.q = function() {
    try {
        var t = {
            type: "keepalive"
        };
        this.i.send(JSON.stringify(t))
    } catch(t) {
        console.log(t)
    }
},
H5sPlayerRTC.prototype.ot = function(t) {
    if (t.candidate) {
        var s;
        console.log("onIceCandidate currentice", t.candidate),
        s = t.candidate,
        console.log("onIceCandidate currentice", s, JSON.stringify(s));
        var e = JSON.parse(JSON.stringify(s));
        e.type = "remoteice",
        console.log("onIceCandidate currentice new", e, JSON.stringify(e)),
        this.i.send(JSON.stringify(e))
    } else console.log("End of candidates.")
},
H5sPlayerRTC.prototype.nt = function(t) {
    var s;
    console.log("Remote track added:" + JSON.stringify(t)),
    s = t.ht ? t.ht[0] : t.stream;
    var e = this.m;
    e.src = URL.createObjectURL(s),
    e.play()
},
H5sPlayerRTC.prototype.ct = function() {
    console.log("createPeerConnection  config: " + JSON.stringify(this.B) + " option:" + JSON.stringify(this.N));
    var s = new RTCPeerConnection(this.B, this.N),
    e = this;
    return s.onicecandidate = function(t) {
        e.ot.call(e, t)
    },
    void 0 !== s.rt ? s.rt = function(t) {
        e.nt.call(e, t)
    }: s.onaddstream = function(t) {
        e.nt.call(e, t)
    },
    s.oniceconnectionstatechange = function(t) {
        console.log("oniceconnectionstatechange  state: " + s.iceConnectionState)
    },
    console.log("Created RTCPeerConnnection with config: " + JSON.stringify(this.B) + "option:" + JSON.stringify(this.N)),
    s
},
H5sPlayerRTC.prototype.lt = function(t) {
    console.log("ProcessRTCOffer", t);
    try {
        this.J = this.ct(),
        this.D.length = 0;
        var s = this;
        this.J.setRemoteDescription(createRTCSessionDescription(t)),
        this.J.createAnswer(this.g).then(function(t) {
            console.log("Create answer:" + JSON.stringify(t)),
            s.J.setLocalDescription(t,
            function() {
                console.log("ProcessRTCOffer createAnswer", t),
                s.i.send(JSON.stringify(t))
            },
            function() {})
        },
        function(t) {
            alert("Create awnser error:" + JSON.stringify(t))
        })
    } catch(t) {
        this.disconnect(),
        alert("connect error: " + t)
    }
},
H5sPlayerRTC.prototype.at = function(t) {
    console.log("ProcessRemoteIce", t);
    try {
        var s = new RTCIceCandidate({
            sdpMLineIndex: t.sdpMLineIndex,
            candidate: t.candidate
        });
        console.log("ProcessRemoteIce", s),
        console.log("Adding ICE candidate :" + JSON.stringify(s)),
        this.J.addIceCandidate(s,
        function() {
            console.log("addIceCandidate OK")
        },
        function(t) {
            console.log("addIceCandidate error:" + JSON.stringify(t))
        })
    } catch(t) {
        alert("connect ProcessRemoteIce error: " + t)
    }
},
H5sPlayerRTC.prototype.F = function(t) {
    console.log("RTC received ", t.data);
    var s = JSON.parse(t.data);
    console.log("Get Message type ", s.type),
    "offer" === s.type && (console.log("Process Message type ", s.type), this.lt(s)),
    "remoteice" === s.type && (console.log("Process Message type ", s.type), this.at(s))
},
H5sPlayerRTC.prototype.K = function(t) {
    this.s.autoplay = !0;
    var s = "api/v1/h5srtcapi";
    s = void 0 === this.C ? this.P.rootpath + s + "?token=" + t + "&session=" + this.P.session: this.P.rootpath + s + "?token=" + t + "&device=" + this.C + "&session=" + this.P.session,
    console.log(s),
    this.i = this.V(s),
    console.log("setupWebSocket", this.i),
    this.i.binaryType = "arraybuffer",
    (this.i.Z = this).i.onmessage = this.F.bind(this),
    this.i.onopen = function() {
        console.log("wsSocket.onopen", this.Z);
        var t = {
            type: "open"
        };
        this.Z.i.send(JSON.stringify(t)),
        this.Z.h = setInterval(this.Z.q.bind(this.Z), 1e3)
    },
    this.i.onclose = function() {
        console.log("wsSocket.onclose", this.Z),
        !0 === this.Z.k ? console.log("wsSocket.onclose disconnect") : this.Z.v = !0,
        this.Z.st(this.Z)
    }
},
H5sPlayerRTC.prototype.st = function(t) {
    console.log("CleanupWebSocket", t),
    clearInterval(t.h),
    t.l = 0,
    t.u = 0,
    t.S = 0
},
H5sPlayerRTC.prototype.connect = function() {
    this.K(this.I),
    this.et = setInterval(this._.bind(this), 3e3)
},
H5sPlayerRTC.prototype.disconnect = function() {
    console.log("disconnect", this),
    this.k = !0,
    clearInterval(this.et),
    null != this.i && (this.i.close(), this.i = null),
    console.log("disconnect", this)
},
H5sPlayerAudio.prototype.V = function(t) {
    var s;
    console.log("H5SWebSocketClient");
    try {
        "http:" == this.P.protocol && (s = "undefined" != typeof MozWebSocket ? new MozWebSocket("ws://" + this.P.host + t) : new WebSocket("ws://" + this.P.host + t)),
        "https:" == this.P.protocol && (console.log(this.P.host), s = "undefined" != typeof MozWebSocket ? new MozWebSocket("wss://" + this.P.host + t) : new WebSocket("wss://" + this.P.host + t)),
        console.log(this.P.host)
    } catch(t) {
        return void alert("error")
    }
    return s
},
H5sPlayerAudio.prototype.q = function() {
    try {
        this.i.send("keepalive")
    } catch(t) {
        console.log(t)
    }
},
H5sPlayerAudio.prototype.F = function(t) {
    for (var s = new Int16Array(t.data), e = s.length, i = this.G.createBuffer(1, e, 8e3), o = 0; o < 1; o++) for (var n = i.getChannelData(o), h = 0; h < e; h++) n[h] = s[h] / 16383.5;
    var c = this.G.createBufferSource();
    c.buffer = i,
    c.connect(this.G.destination),
    c.start()
},
H5sPlayerAudio.prototype.st = function(t) {
    console.log("CleanupWebSocket", t),
    clearInterval(t.h)
},
H5sPlayerAudio.prototype.K = function(t) {
    var s = "api/v1/h5saudapi";
    s = this.P.rootpath + s + "?token=" + t + "&session=" + this.P.session,
    console.log(s),
    this.i = this.V(s),
    console.log("setupWebSocket for audio", this.i),
    this.i.binaryType = "arraybuffer",
    (this.i.Z = this).i.onmessage = this.F.bind(this),
    this.i.onopen = function() {
        console.log("wsSocket.onopen", this.Z),
        this.Z.h = setInterval(this.Z.q.bind(this.Z), 1e3)
    },
    this.i.onclose = function() {
        console.log("wsSocket.onclose", this.Z),
        this.Z.st(this.Z)
    }
},
H5sPlayerAudio.prototype.connect = function() {
    this.K(this.I)
},
H5sPlayerAudio.prototype.disconnect = function() {
    console.log("disconnect", this),
    null != this.i && (this.i.close(), this.i = null),
    console.log("disconnect", this)
},
H5sPlayerAudBack.prototype.V = function(t) {
    var s;
    console.log("H5SWebSocketClient");
    try {
        "http:" == this.P.protocol && (s = "undefined" != typeof MozWebSocket ? new MozWebSocket("ws://" + this.P.host + t) : new WebSocket("ws://" + this.P.host + t)),
        "https:" == this.P.protocol && (console.log(this.P.host), s = "undefined" != typeof MozWebSocket ? new MozWebSocket("wss://" + this.P.host + t) : new WebSocket("wss://" + this.P.host + t)),
        console.log(this.P.host)
    } catch(t) {
        return void alert("error")
    }
    return s
},
H5sPlayerAudBack.prototype.q = function() {
    try {
        this.i.send("keepalive")
    } catch(t) {
        console.log(t)
    }
},
H5sPlayerAudBack.prototype.F = function(t) {},
H5sPlayerAudBack.prototype.st = function(t) {
    console.log("CleanupWebSocket", t),
    clearInterval(t.h)
},
H5sPlayerAudBack.prototype.ut = function(t) {
    console.log("wsSocket.onopen", this);
    try {
        navigator.getUserMedia({
            s: !1,
            dt: !0
        },
        this.ft.bind(this))
    } catch(t) {
        return void alert("Audio intecomm error", t)
    }
},
H5sPlayerAudBack.prototype.K = function(t) {
    var s = "api/v1/h5saudbackapi";
    s = this.P.rootpath + s + "?token=" + t + "&session=" + this.P.session,
    console.log(s),
    this.i = this.V(s),
    console.log("setupWebSocket for audio back", this.i),
    this.i.binaryType = "arraybuffer",
    (this.i.Z = this).i.onmessage = this.F.bind(this),
    this.i.onopen = this.ut.bind(this),
    this.i.onclose = function() {
        console.log("wsSocket.onclose", this.Z),
        this.Z.st(this.Z)
    }
},
H5sPlayerAudBack.prototype.St = function(t) {
    var s = float32ToInt16(t.inputBuffer.getChannelData(0));
    this.i.send(s)
},
H5sPlayerAudBack.prototype.ft = function(t) {
    try {
        var s = this.G.createMediaStreamSource(t);
        console.log("sampleRate", this.G.sampleRate);
        var e = this.G.createScriptProcessor(256, 1, 1);
        s.connect(e),
        e.connect(this.G.destination),
        e.onaudioprocess = this.St.bind(this)
    } catch(t) {
        return void alert("Audio intecomm error", t)
    }
},
H5sPlayerAudBack.prototype.connect = function() {
    this.K(this.I)
},
H5sPlayerAudBack.prototype.disconnect = function() {
    console.log("disconnect", this),
    null != this.i && (this.i.close(), this.i = null),
    console.log("disconnect", this)
};