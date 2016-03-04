//
//  CNotification.h
//  TestDemo
//
//  Created by shscce on 15/5/28.
//  Copyright (c) 2015年 shscce. All rights reserved.
//

/**
 *   使用注意:
 *   在plist文件中加入两条键值对:
 *   View controller-based status bar appearance   --> NO
 *   Status bar style                              --> UIStatusBarStyleDefault
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString *const text_font_key = @"CN_TEXT_FONT_KEY" ;
static NSString *const text_color_key = @"CN_TEXT_COLOR_KEY" ;
static NSString *const delay_second_key = @"CN_DELAY_SECOND_KEY" ;
static NSString *const background_color_key = @"CN_BACKGROUND_COLOR_KEY" ;

static CGFloat   const CNotification_view_height = 40.f ;

typedef void(^CNCompleteBlock)();

@interface CNotificationManager : NSObject

@property (nonatomic,assign) CGFloat delaySeconds;           //延迟时间(单位:秒)
@property (nonatomic,strong) UIFont  *textFont;              //字体大小
@property (nonatomic,strong) UIColor *textColor;             //字体颜色
@property (nonatomic,strong) UIColor *backgroundColor;       //背景色
@property (nonatomic,  copy) CNCompleteBlock completeBlock;  //完成的回调,可用来执行其他事件

+ (instancetype)shareManager;
+ (void)setOptions:(NSDictionary *)options;


+ (void)showMessage:(NSString *)message;
+ (void)showMessage:(NSString *)message withOptions:(NSDictionary *)options;
+ (void)showMessage:(NSString *)message withOptions:(NSDictionary *)options completeBlock:(void(^)())completeBlock;

@end
