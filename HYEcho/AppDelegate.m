//
//  AppDelegate.m
//  HYEcho
//
//  Created by AiDong on 15/11/6.
//  Copyright © 2015年 AiDong. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    ViewController *tabBarVC = [[ViewController alloc] init];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = tabBarVC ;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    //显示锁屏信息
    if ([PlayHelper sharePlayHelper].isPlay){
        [[EchoPlayMusicController shareEchoPlayViewController] configNowPlayingInfoCenter];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//重写父类方法 处理点击事件
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlStop:
            {
                NSLog(@"停止事件");
            }
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:
            {
                NSLog(@"线控播放");
                if ([PlayHelper sharePlayHelper].isPlay) {
                    [[EchoPlayMusicController shareEchoPlayViewController] pauseMusic];
                }else{
                    [[EchoPlayMusicController shareEchoPlayViewController] playMusic];
                }
            }
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
            {
                //点击上一曲或者耳机点击3次
                NSLog(@"上一曲");
                [[EchoPlayMusicController shareEchoPlayViewController] previousMusic];
            }
                break;
            case UIEventSubtypeRemoteControlNextTrack:
            {
                //点击下一曲或者耳机点击2次
                NSLog(@"下一曲");
                [[EchoPlayMusicController shareEchoPlayViewController] nextMusic];
            }
                break;
            case UIEventSubtypeRemoteControlPlay:
            {
                NSLog(@"后台播放");
                [[EchoPlayMusicController shareEchoPlayViewController] playMusic];
            }
                break;
            case UIEventSubtypeRemoteControlPause:
            {
                NSLog(@"后台暂停");
                [[EchoPlayMusicController shareEchoPlayViewController] pauseMusic];
            }
                break;
            case UIEventSubtypeRemoteControlBeginSeekingBackward:
            {
                NSLog(@"快退开始");
            }
                break;
            case UIEventSubtypeRemoteControlEndSeekingBackward:
            {
                NSLog(@"快退结束");
            }
                break;
            case UIEventSubtypeRemoteControlBeginSeekingForward:
            {
                NSLog(@"快进开始");
            }
                break;
            case UIEventSubtypeRemoteControlEndSeekingForward:
            {
                NSLog(@"快进结束");
            }
                break;
                
            default:
                break;
        }
    }
}

@end
