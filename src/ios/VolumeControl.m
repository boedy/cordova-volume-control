#import "VolumeControl.h"
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>

@implementation VolumeControl

static void *OutputVolumeContext = &OutputVolumeContext;

- (void)pluginInitialize
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appHasGoneInforeground:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [super pluginInitialize];
}

- (void)initCommand:(CDVInvokedUrlCommand*)command
{
    NSNumber* hideVolumeNotification = nil;
    NSNumber* volume = nil;
    
    NSDictionary* options = [command argumentAtIndex:0 withDefault:nil];
    if(options != nil){
        hideVolumeNotification = [options objectForKey:@"hideVolumeNotification"];
        volume = [options valueForKey:@"volume"];
    }
    self.callbackId = command.callbackId;
    
    if (!self.avSession) {
        self.avSession = [AVAudioSession sharedInstance];
        [self.avSession setActive: true error:nil];
    }
    
    if(hideVolumeNotification != nil && [hideVolumeNotification boolValue]){
        [self hideVolumeNotifications];
    }
    
    if(volume != nil ){
        [self setVolume:[volume floatValue]];
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(100 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        [self startObservingVolumeChanges];
    });
}


- (void)destroyCommand:(CDVInvokedUrlCommand *)command
{
    [self stopObservingVolumeChanges];
    [self showVolumeNotifications];
    // callback one last time to clear the callback function on JS side
    if (self.callbackId) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT];
        [result setKeepCallbackAsBool:NO];
        [self.commandDelegate sendPluginResult:result callbackId:self.callbackId];
    }
    self.callbackId = nil;
}


- (void)setVolumeCommand:(CDVInvokedUrlCommand *)command
{
    NSNumber* volume = [command argumentAtIndex:0 withDefault:nil];
    if(volume != nil){
        [self setVolume:[volume floatValue]];
    }
}


- (void)startObservingVolumeChanges
{
    [self.avSession setActive: true error:nil];
    self.launchVolume = self.avSession.outputVolume;
    [self.avSession addObserver:self forKeyPath: @"outputVolume" options:(NSKeyValueObservingOptionInitial |
                                                                          NSKeyValueObservingOptionNew) context:OutputVolumeContext];
}

- (void)stopObservingVolumeChanges
{
    [self.avSession removeObserver:self forKeyPath: @"outputVolume" context:OutputVolumeContext];
}

- (void)showVolumeNotifications
{
    if(self.volumeView){
        [self.volumeView removeFromSuperview];
        self.volumeView = nil;
    }
    
}
- (void)hideVolumeNotifications
{
    if ( ! self.volumeView){
        CGRect frame = CGRectMake(0, 0, 10, 0);
        self.volumeView = [[MPVolumeView alloc] initWithFrame:frame];
        [self.volumeView sizeToFit];
        [[[[UIApplication sharedApplication] windows] firstObject] insertSubview:self.volumeView atIndex:0];
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (context == OutputVolumeContext) {
        CDVPluginResult* result = [CDVPluginResult
                                   resultWithStatus:CDVCommandStatus_OK
                                   messageAsDouble:self.avSession.outputVolume];
        [result setKeepCallbackAsBool:YES];
        
        [self.commandDelegate sendPluginResult:result callbackId:self.callbackId];
    }
}

- (void)setVolume:(float)level
{
    [[MPMusicPlayerController applicationMusicPlayer] setVolume:level];
}

- (void)appHasGoneInforeground:(NSNotification*)notification {
    [self stopObservingVolumeChanges];
    [self startObservingVolumeChanges];
}


@end


