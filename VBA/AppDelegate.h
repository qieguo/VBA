//
//  AppDelegate.h
//  VBA
//
//  Created by ioshack on 13-11-21.
//  Copyright (c) 2013年 ioshack. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVFoundation;

@interface AppDelegate : UIResponder <UIApplicationDelegate,AVAudioPlayerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end
