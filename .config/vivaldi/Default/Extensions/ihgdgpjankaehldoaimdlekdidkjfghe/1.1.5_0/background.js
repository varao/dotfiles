var preLoad = function callback(){
  $(function() {
    var viewerElement = document.getElementById('viewer');
    var myWebViewer = new PDFTron.WebViewer({
        type: "html5",
        path: "lib",
        documentType: "pdf",
        config: "config.js",
        showLocalFilePicker: true,
        enableAnnotations: true,
        useDownloader: false
    }, viewerElement);
});
};

chrome.runtime.onInstalled.addListener(preLoad.bind(this));

chrome.runtime.onStartup.addListener(preLoad.bind(this));

(function() {
  "use strict";

  function e(e, t) {
    chrome.tabs.create({
      url: e.linkUrl
    });
  }
  chrome.contextMenus.create({
    title: "Open with Xodo PDF",
    contexts: ["link"],
    onclick: e
  })
}());