//
//  AppDelegate.m
//  VBA
//
//  Created by ioshack on 13-11-21.
//  Copyright (c) 2013年 ioshack. All rights reserved.
//

#import "AppDelegate.h"
#import "PrivateHeader.h"
@import AudioToolbox;

@implementation AppDelegate

static void callBack(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    if ([(__bridge NSString *)name isEqualToString:@"kCTCallStatusChangeNotification"]) {
        int callstate = [[(__bridge NSDictionary *)userInfo objectForKey:@"kCTCallStatus"] intValue];
        if (callstate == 1) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
    }
}

- (void)playBackgroundSoundEffect {
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0))
    {
        [[AVAudioSession sharedInstance] setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    }
    else
    {
        [[AVAudioSession sharedInstance] setActive:YES withFlags:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    }
    NSString *soundFilePath =
    [[NSBundle mainBundle] pathForResource: @"nosound300"
                                    ofType: @"m4a"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    self.audioPlayer =
    [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL
                                           error: nil];
    _audioPlayer.delegate = self;
    [_audioPlayer prepareToPlay];
    _audioPlayer.numberOfLoops = -1;
    [_audioPlayer play];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    CTTelephonyCenterAddObserver(CTTelephonyCenterGetDefault(), NULL, &callBack, CFSTR("kCTCallStatusChangeNotification"), NULL, CFNotificationSuspensionBehaviorHold);
    [self playBackgroundSoundEffect];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    CTTelephonyCenterRemoveObserver(CTTelephonyCenterGetDefault(), NULL, CFSTR("kCTCallStatusChangeNotification"), NULL);
    NSLog(@"exit");
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    [_audioPlayer pause];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags
{
    if (flags == AVAudioSessionInterruptionFlags_ShouldResume)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1), dispatch_get_main_queue(), ^{
            [_audioPlayer play];
        });
    }
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
    if (flags == AVAudioSessionInterruptionOptionShouldResume)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1), dispatch_get_main_queue(), ^{
            [_audioPlayer play];
        });
    }
}

@end
