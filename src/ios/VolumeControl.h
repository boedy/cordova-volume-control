#import <Cordova/CDV.h>
#import <AVFoundation/AVFoundation.h>

@interface VolumeControl : CDVPlugin
{
    AVAudioSession *avSession;
    UIView *volumeView;
    NSString *callbackId;
    float launchVolume;
}
@property(nonatomic, strong) AVAudioSession *avSession;
@property(nonatomic, strong) CDVInvokedUrlCommand *callback;
@property(nonatomic, retain) UIView *volumeView;
@property(nonatomic) float launchVolume;
@property(strong) NSString *callbackId;
- (void)initCommand:(CDVInvokedUrlCommand *)command;
- (void)destroyCommand:(CDVInvokedUrlCommand *)command;
- (void)setVolumeCommand:(CDVInvokedUrlCommand *)command;
- (void)showVolumeNotifications;
- (void)hideVolumeNotifications;
- (void)setVolume:(float)level;
- (void)getVolumeCommand:(CDVInvokedUrlCommand *)command;

@end
