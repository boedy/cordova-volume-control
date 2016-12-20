module.exports = {
  init: function (options, successCallback, errorCallback) {
    cordova.exec(successCallback, errorCallback, "VolumeControl", "initCommand", [options]);
  },
  destroy: function(){
    cordova.exec(null, null, "VolumeControl", "destroyCommand", null);
  },
  setVolume: function(volume){
    cordova.exec(null, null, "VolumeControl", "setVolumeCommand", [volume]);
  }
};

