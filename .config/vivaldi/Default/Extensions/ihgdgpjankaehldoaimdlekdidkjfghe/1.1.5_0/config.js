CoreControls.getDefaultPdfBackendType().then(function(backendType) {
  var workerHandlers = {
    workerLoadingProgress: function(percentComplete) {
      if (readerControl) {
        readerControl.fireEvent('workerLoadingProgress', percentComplete);
      }
    }
  };

  CoreControls.preloadPDFWorker(backendType, workerHandlers, {
    useEmscriptenWhileLoading: false
  });
});