package com.cordova.volumeControl;

import android.content.Context;
import android.media.AudioManager;

import com.cordova.volumeControl.VolumeObserver;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class VolumeControl extends CordovaPlugin {

    private VolumeObserver observer;

    @Override
    public boolean execute(String action, JSONArray data, CallbackContext callbackContext) throws JSONException {

        if (action.equals("initCommand")) {
            JSONObject options = data.getJSONObject(0);
            if(options.has("volume") && this.observer == null){
                this.setVolume(options.getDouble("volume"));
            }
            this.init(callbackContext);

            return true;
        } else if(action.equals("destroyCommand")){
            this.destroy();
            return true;
        } else if(action.equals("setVolumeCommand")){
            double volume = data.getDouble(0);
            this.setVolume(volume);
            return true;
        }
        return false;

    }

    public void init(CallbackContext callbackContext){
        if( this.observer != null){
            return;
        }

        Context context=this.cordova.getActivity().getApplicationContext();
        this.observer = new VolumeObserver(callbackContext, context, null);
        context.getContentResolver().registerContentObserver(android.provider.Settings.System.CONTENT_URI, true, this.observer);

    }

    public void destroy(){
        if( this.observer != null){
            Context context=this.cordova.getActivity().getApplicationContext();
            context.getContentResolver().unregisterContentObserver(this.observer);
            this.observer = null;
        }
    }

    public void setVolume(double volume){
        Context context=this.cordova.getActivity().getApplicationContext();
        AudioManager audioManager = (AudioManager)context.getSystemService(Context.AUDIO_SERVICE);
        int maxVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC);

        audioManager.setStreamVolume(AudioManager.STREAM_MUSIC, (int)(maxVolume * volume) , 0);
    }
}

