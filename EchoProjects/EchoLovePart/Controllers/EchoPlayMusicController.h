//
//  EchoPlayMusicController.h
//  HYEcho
//
//  Created by AiDong on 15/11/10.
//  Copyright © 2015年 AiDong. All rights reserved.
//

#import "EchoBaseViewController.h"

@interface EchoPlayMusicController : EchoBaseViewController

@property (nonatomic, assign) NSInteger index ;
@property (nonatomic, assign) BOOL      isLocal ;

#pragma mark --- 公共方法

/**
 *  全局获取的单例方法
 */
+ (instancetype)shareEchoPlayViewController ;

/**
 *  播放音乐前期准备工作 <加载音乐信息, 评论信息, 刷新视图>
 */
- (void)prepareForPlaying ;

/**
 *  下一曲
 */
- (void)nextMusic ;

/**
 *  上一曲
 */
- (void)previousMusic ;

/**
 *  播放音乐
 */
- (void)playMusic ;

/**
 *  暂停音乐
 */
- (void)pauseMusic ;

/**
 *  获取后台运行在屏幕上显示的信息
 */
- (void)configNowPlayingInfoCenter;

@end
