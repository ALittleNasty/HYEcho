//
//  Banner.h
//  HYEcho
//
//  Created by AiDong on 15/11/10.
//  Copyright © 2015年 AiDong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Banner : NSObject

@property (nonatomic, copy) NSString *create_user_id;
//@property (nonatomic, copy) NSString *extension;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *click_count;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *turn;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *platform;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *ad_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *online;
@property (nonatomic, copy) NSString *ID;//id
@property (nonatomic, copy) NSString *show_count;
@property (nonatomic, copy) NSString *position;

@end

/*
 {
 "ad_id" = 9;
 "android_down_popup" =             {
                                     icon = "";
                                     text = "";
                                     title = "";
                                     };
 "click_count" = 0;
 content = "406998 \U9996\U98756";
 "create_time" = 1446537664;
 "create_user_id" = 6486826;
 "end_time" = 1447487998;
 extension = "{\"state_code\":\"\",\"android_down_popup_icon\":\"\",\"android_down_popup_title\":\"\",  
              \"android_down_popup_text\":\"\"}";
 id = 397;
 name = "(\U5185\U5bb9\Uff09\U7ffb\U5531";
 online = 1;
 pic = "http://echo-image.qiniucdn.com/FmefkvNuD9jhF8Z3FPWGWxvqnVXq";
 platform = 0;
 position = 4;
 sex = 2;
 "show_count" = 0;
 sound =             {
                     id = 406998;
                     name = "\U60ca\U8273\U7ffb\U5531 \U5973\U58f0\U5f00\U53e3\U4fbf\U6c89\U6ca6 The Monster";
                     pic = "http://echo-image.qiniucdn.com/Fg9Or380Foxr-1mFSJVenjV2RCUP";
                     source = "http://7fvgtj.com2.z0.glb.qiniucdn.com/355ade30181d12ccb5753b6373ce7675";
                     };
 "start_time" = 1446537598;
 turn = 15;
 type = 3;
 url = 406998;
 },

 */