$(function(options) {
  window.document.title = "Xodo";

  var viewerElement = document.getElementById('viewer');
  var myWebViewer = new PDFTron.WebViewer({
    type: "html5",
    path: "lib",
    documentType: "pdf",
    config: "config.js",
    showLocalFilePicker: true,
    enableAnnotations: true,
    useDownloader: false,
    initialDoc: window.location.hash.substring(1),
    l: "Xodo:WEBCPU:1::B:AMS(20161230):A269AEE8497BA616FB9EB6EF4FDEE6AAFE629A39F5C7"
  }, viewerElement);

  $(viewerElement).on('ready', function() {
    var xodoLogo = $('<span class="left-aligned">' +
           '<span class="navbar-brand">' +
           '<a href="https://www.xodo.com/" target="_blank" id="backToXodoButton">' +
           '<img src="../../logo_transparent.png" alt="Xodo" title="Xodo" height="30" class="hidden-sm">' +
           '</a>' +
           '</span>' +
           '</span>');
    var doc = $(viewerElement).find('iframe')[0].contentDocument;
    $(doc).find("#control").append(xodoLogo);
  });

  // Chrome generates print url by appending ?print=true to file url.
  // if it is present then this is a request to print
  function getParameterByName(url, name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(url);
    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
  }

  $(viewerElement).on('documentLoaded', function() {
    document.title = myWebViewer.getInstance().filename;
  });

  if(getParameterByName(location.hash, 'print') === "true"){
    $(viewerElement).on('documentLoaded', function(){
      myWebViewer.getInstance().print();
    });
  }
});