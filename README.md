# cordova-simple-volume
Control volume and Receive volume events (iOS /Android)

### Supported Platforms

- iOS
- Android

## Installation

    cordova plugin add cordova-simple-volume -S

### Methods

- `volumeControl.init({options}, callbackVolumeChanges);` Initializes plugin
- `volumeControl.destroy();` Unset plugin
- `volumeControl.setVolume(float 0 <=> 1);` Set volume


### volumeControl.init options parameter

- __volume__: Set volume during initialization
- __hideVolumeNotification__: (iOS only) hides the volume UI during volume change

### Quick Example

```js
var options = {volume: 0.5, hideVolumeNotification:true};

//init
volumeControl.init(options, function(vol){
  console.log("Volume changed" , vol);
});
```

### cordova ios volumedownbutton / volumeupbutton events polyfill
```js
document.addEventListener("deviceready", () => {
  var curVolume = null
  if (cordova.platformId === 'ios') {
    volumeControl.init({}, (vol) => {
      if (curVolume !== null) {
        if (curVolume <= vol) {
          document.dispatchEvent(new Event('volumedownbutton'))
        } else {
          document.dispatchEvent(new Event('volumeupbutton'))
        }
      }
      curVolume = vol
      console.log("Volume changed", vol);
    });
  }
}, false);
```

### getVolume() example
```js
volumeControl.getVolume().then((vol) => {
  console.log("Volume" , vol);
});
```