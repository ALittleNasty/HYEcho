//
//  PlayHelper.m
//  HYEcho
//
//  Created by AiDong on 15/11/10.
//  Copyright © 2015年 AiDong. All rights reserved.
//

#import "PlayHelper.h"
#import <AVFoundation/AVFoundation.h>

@interface PlayHelper ()

@property (nonatomic, strong) AVPlayer *player ;
@property (nonatomic, strong) NSTimer  *timer ;

@end

@implementation PlayHelper

- (instancetype)init
{
    self = [super init];
    if (self) {
        //监听并且通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didToStop) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        
        //设置播放会话 在后台可以继续播放（还需要设置程序允许后台运行模式）
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        if (![[AVAudioSession sharedInstance] setActive:YES error:nil]) {
            NSLog(@"Failed to set up a session.");
        }
    }
    return self ;
}
- (void)didToStop
{
    if (self.delegate != nil &&
        [self.delegate respondsToSelector:@selector(didStop)]) {
        [self.delegate didStop];
    }
}

#pragma mark --- 创建单例方法
//  单例方法
+ (instancetype)sharePlayHelper
{
    static PlayHelper *playHelper = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playHelper = [[PlayHelper alloc] init];
    });
    return playHelper ;
}
//  给一个音乐链接就可以播放音乐
-(void)playInternetMusicWithURL:(NSString *)url
{
    NSURL *musicUrl = nil ;
    
    if ([url hasPrefix:@"http"]) {
        musicUrl = [NSURL URLWithString:url] ;
    }else{
        musicUrl = [NSURL fileURLWithPath:url] ;
    }
    
    //1. 拿到播放条目
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:musicUrl];
    [self.player replaceCurrentItemWithPlayerItem:item];
    //2. 暂停播放
    [self pause];
    //3. 切换当前音乐
    [self.player replaceCurrentItemWithPlayerItem:item];
    //这样需要加载才会播放  这里有一个更好的方法: KVO 监听 status 新值
    //这个属性是什么意思 AVPlayerStatus 枚举 代表播放器的状态，
    
    [self.player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //4. 播放音乐
    [self play];
}
//  观察者执行事件
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        if (self.player.status == AVPlayerStatusReadyToPlay) {
            [self play] ;
        }
    }
}

// 播放
- (void)play
{
    if (self.isPlay == YES) {
        return ;
    }else{
        [self.player play];
        self.isPlay = YES ;
    }
    
    if (self.timer != nil) {
        return ;
    }
    
    //每隔1秒就让代理执行一个方法，这个方法是传值
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeAction) userInfo:nil repeats:YES] ;
}
// 通过定时器可以拿到播放时间 , 提供给外界使用
- (void)timeAction
{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(playingWithTime:)])
    {
        NSTimeInterval time = self.player.currentTime.value/self.player.currentTime.timescale ;
        [self.delegate playingWithTime:time];
    }
}
// 暂停
-(void)pause
{
    if (self.isPlay == NO) {
        return ;
    }else{
        [self.player pause];
        self.isPlay = NO ;
    }
    
    //停止定时器并置空
    [self.timer invalidate];
    self.timer = nil ;
}
// 制定播放时间播放音乐
-(void)seekToTime:(double)time
{
    [self.player seekToTime:CMTimeMakeWithSeconds(time, self.player.currentTime.timescale) completionHandler:^(BOOL finished) {
        [self play];
    }];
}

// 音量
- (void)setSoundValue:(float)soundValue
{
    self.player.volume = soundValue ;
}
- (float)soundValue
{
    return self.player.volume ;
}


#pragma mark - 懒加载
-(AVPlayer *)player
{
    if (!_player) {
        _player = [[AVPlayer alloc] init];
    }
    return _player;
}
@end
