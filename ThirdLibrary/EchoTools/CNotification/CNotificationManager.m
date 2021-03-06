//
//  CNotification.m
//  TestDemo
//
//  Created by shscce on 15/5/28.
//  Copyright (c) 2015年 shscce. All rights reserved.
//

#import "CNotificationManager.h"



@interface CNotificationManager()

@property (nonatomic,readonly,getter=isShowing) BOOL showing;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView  *backgroundView;

@end

@implementation CNotificationManager

- (instancetype)init{
    if (self  = [super init]) {
        self.backgroundColor = [UIColor blackColor];
        self.textColor = [UIColor whiteColor];
        self.textFont = [UIFont systemFontOfSize:14.f];
        self.delaySeconds = 1.5f;
        [self.backgroundView addSubview:self.titleLabel];
        
        UITapGestureRecognizer *dismissTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissNotification)];
        [self.backgroundView addGestureRecognizer:dismissTap];
    }
    return self;
}

+ (instancetype)shareManager{
    static dispatch_once_t onceToken;
    static id shareInstance;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

+ (void)setOptions:(NSDictionary *)options{
    if (!options) {
        return;
    }
    if (options[background_color_key]) {
        [CNotificationManager shareManager].backgroundColor = options[background_color_key];
    }
    if (options[text_color_key]) {
        [CNotificationManager shareManager].textColor = options[text_color_key];
    }
    if (options[text_font_key]) {
        [CNotificationManager shareManager].textFont = options[text_font_key];
    }
    if (options[delay_second_key]){
        [CNotificationManager shareManager].delaySeconds = [options[delay_second_key] floatValue];
    }
}

+ (void)showMessage:(NSString *)message
{
    [CNotificationManager showMessage:message withOptions:nil completeBlock:nil];
}

+ (void)showMessage:(NSString *)message withOptions:(NSDictionary *)options
{
    [CNotificationManager showMessage:message withOptions:options completeBlock:nil];
}

+ (void)showMessage:(NSString *)message withOptions:(NSDictionary *)options completeBlock:(void(^)())completeBlock
{
    [CNotificationManager shareManager].completeBlock = completeBlock;
    [CNotificationManager setOptions:options];
    if ([[CNotificationManager shareManager] isShowing]) {
        [[CNotificationManager shareManager] reDisplayTitleLabel:message];
    }else{
        [[CNotificationManager shareManager] showNotification:message];
    }
}


#pragma mark - Public Methods
/**
 *  重新设置titleLabel backgroundView 背景等
 *
 *  @param message 需要显示的message
 */
- (void)setupViewOptionsWithMessage:(NSString *)message
{
    self.backgroundView.backgroundColor = self.backgroundColor;
    self.titleLabel.textColor = self.textColor;
    self.titleLabel.font = self.textFont;
    self.titleLabel.text = message;
}


/**
 *  显示一条消息通知
 *
 *  @param message 需要显示的信息
 */
- (void)showNotification:(NSString *)message{
    
    [UIApplication sharedApplication].statusBarHidden = YES ;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissNotification) object:nil];
    self.backgroundView.frame = CGRectMake(0, -CNotification_view_height, self.backgroundView.frame.size.width, CNotification_view_height);
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.backgroundView];
    [self setupViewOptionsWithMessage:message];
    [self resizeTitleLabelFrame];
    [UIView animateWithDuration:.5 animations:^{
        self.backgroundView.frame = CGRectMake(0, 0, self.backgroundView.frame.size.width, CNotification_view_height);
    } completion:^(BOOL finished) {
        [self performSelector:@selector(dismissNotification) withObject:nil afterDelay:self.delaySeconds];
    }];
}

/**
 *  隐藏通知
 */
- (void)dismissNotification{
    if (!self.showing) {
        return;
    }
    [UIView animateWithDuration:.5 animations:^{
        self.backgroundView.frame = CGRectMake(0, -CNotification_view_height, self.backgroundView.frame.size.width, CNotification_view_height);
        
    } completion:^(BOOL finished) {
        [self.backgroundView removeFromSuperview];
        if (self.completeBlock) {
            self.completeBlock();
            self.completeBlock = nil;
        }
        [UIApplication sharedApplication].statusBarHidden = NO ;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault ;
    }];
    
}

#pragma mark - Private Methods

/**
 *  当消息通知已经显示时  重新显示titleLabel
 *
 *  @param message 需要显示的消息
 */
- (void)reDisplayTitleLabel:(NSString *)message{
    //取消之前通知隐藏notification
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissNotification) object:nil];
    [UIView animateWithDuration:.2 animations:^{
        self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, CNotification_view_height + 10, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
    } completion:^(BOOL finished) {
        [self setupViewOptionsWithMessage:message];
        [self resizeTitleLabelFrame];
        self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, -10, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
        [UIView animateWithDuration:.1 animations:^{
            [self resizeTitleLabelFrame];
        } completion:^(BOOL finished) {
            //重新定义调用延迟隐藏notification
            [self performSelector:@selector(dismissNotification) withObject:nil afterDelay:self.delaySeconds];
        }];
    }];
}

- (void)resizeTitleLabelFrame
{
    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.size = [self.titleLabel sizeThatFits:CGSizeMake([UIScreen mainScreen].applicationFrame.size.width - 40, 36)];
    titleFrame.origin = CGPointMake(self.backgroundView.frame.size.width/2 - titleFrame.size.width/2, self.backgroundView.frame.size.height/2 - titleFrame.size.height/2 );
    self.titleLabel.frame = titleFrame;
}

#pragma mark - getters & setters
- (UIView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, -CNotification_view_height, [UIScreen mainScreen].applicationFrame.size.width, CNotification_view_height)];
        _backgroundView.clipsToBounds = YES;
    }
    return _backgroundView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (BOOL)isShowing
{
    return self.backgroundView && self.backgroundView.superview;
}

@end
