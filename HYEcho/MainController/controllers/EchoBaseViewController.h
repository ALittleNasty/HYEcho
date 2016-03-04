//
//  EchoBaseViewController.h
//  HYEcho
//
//  Created by AiDong on 15/11/9.
//  Copyright © 2015年 AiDong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BackBlock)(NSDictionary *params);

@interface EchoBaseViewController : UIViewController

/**
 *  返回上一级的公共方法
 *
 *  @param block 返回的回调block,有参数
 */
- (void)backItemClickWithCompleteBlock:(BackBlock)block ;

@end
