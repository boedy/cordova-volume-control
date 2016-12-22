# cordova-volume-control
Control volume and Receive volume events (iOS /Android)

### Supported Platforms

- iOS
- Android

## Installation

    cordova plugin add https://github.com/boedy/cordova-volume-control --save

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
