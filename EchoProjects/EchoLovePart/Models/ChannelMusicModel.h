//
//  ChannelMusicModel.h
//  HYEcho
//
//  Created by AiDong on 15/11/10.
//  Copyright © 2015年 AiDong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface ChannelMusicModel : NSObject

@property (nonatomic, copy) NSString *channel_id;
@property (nonatomic, copy) NSString *commend_time;
@property (nonatomic, copy) NSString *comment_count;
@property (nonatomic, copy) NSString *ID;//id
@property (nonatomic, copy) NSString *is_hot;
@property (nonatomic, copy) NSString *length;
@property (nonatomic, copy) NSString *like_count;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *pic_100;
@property (nonatomic, copy) NSString *pic_1080;
@property (nonatomic, copy) NSString *pic_200;
@property (nonatomic, copy) NSString *pic_500;
@property (nonatomic, copy) NSString *pic_640;
@property (nonatomic, copy) NSString *pic_750;
@property (nonatomic, copy) NSString *share_count;
@property (nonatomic, copy) NSString *source;//音频地址
@property (nonatomic, copy) NSString *status_mask;
@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, strong) User *user ;

@end
