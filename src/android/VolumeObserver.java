package com.cordova.volumeControl;

import android.content.Context;
import android.database.ContentObserver;
import android.media.AudioManager;
import android.os.Handler;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;


public class VolumeObserver extends ContentObserver {

    private AudioManager audioManager;
    private int volume;
    private CallbackContext callbackContext;

    public VolumeObserver(CallbackContext callbackContext, Context context, Handler handler) {
        super(handler);
        this.callbackContext = callbackContext;
        audioManager = (AudioManager) context.getSystemService(Context.AUDIO_SERVICE);
        this.volume = audioManager.getStreamVolume(AudioManager.STREAM_MUSIC);
    }

    @Override
    public boolean deliverSelfNotifications() {
        return false;
    }

    @Override
    public void onChange(boolean selfChange) {
        int currentVolume = audioManager.getStreamVolume(AudioManager.STREAM_MUSIC);
        if(currentVolume != this.volume){
            int maxVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC);
            PluginResult resultA = new PluginResult(PluginResult.Status.OK, ((float)currentVolume / (float)maxVolume));
            resultA.setKeepCallback(true);
            callbackContext.sendPluginResult(resultA);
            this.volume = currentVolume;
        }
    }
}

