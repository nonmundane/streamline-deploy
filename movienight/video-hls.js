/// <reference path="./both.js" />

function initPlayer() {
    if (navigator.userAgent.match(/(iPhone|iPod|iPad)/i)) {
        var videoElement = document.getElementById("videoElement");
        videoElement.src = "http://HOSTNAME.DOMAINNAME/master.m3u8";
        videoElement.autoplay = true;
    }
    else if(Hls.isSupported()) {
        var videoElement = document.getElementById("videoElement");
        var hls = new Hls();
        hls.loadSource("http://HOSTNAME.DOMAINNAME/master.m3u8");
        hls.attachMedia(videoElement);
        hls.on(Hls.Events.MANIFEST_PARSED,function() {
          videoElement.play();
        });
    }
let overlay = document.querySelector('#videoOverlay');
overlay.onclick = () => {
    overlay.style.display = 'none';
    videoElement.muted = false;
};
}

window.addEventListener("load", initPlayer);