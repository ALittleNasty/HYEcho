//
//  PlayHelper.h
//  HYEcho
//
//  Created by AiDong on 15/11/10.
//  Copyright © 2015年 AiDong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PlayHelperDelegate <NSObject>

/** 
 *  给外界提供当前播放时间 
 */
- (void)playingWithTime:(NSTimeInterval)time ;
/**
 *  告知外界播放结束
 */
- (void)didStop ;

@end

@interface PlayHelper : NSObject

#pragma mark --- 声明属性
@property (nonatomic, assign) BOOL isPlay ;
@property (nonatomic, assign) float soundValue ;
@property (nonatomic,   weak) id <PlayHelperDelegate> delegate ;


#pragma mark --- 公共方法

+ (instancetype)sharePlayHelper ;

/**
 *  希望给其一个url 其就可以播放，这属于播放网络音乐 名字怎么起呢？
 *
 *  @param url 音频的链接
 */
- (void)playInternetMusicWithURL:(NSString *)url;

/**
 *  播放
 */
- (void) play;

/**
 *  暂停
 */
- (void) pause;

/**
 *  播放指定时间
 *
 *  @param time 时间点
 */
- (void) seekToTime:(double)time;

@end
