//
//  ChannelMusicModel.m
//  HYEcho
//
//  Created by AiDong on 15/11/10.
//  Copyright © 2015年 AiDong. All rights reserved.
//

#import "ChannelMusicModel.h"

@implementation ChannelMusicModel

//用ID替换model中的id
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}

@end
