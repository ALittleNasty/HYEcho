//
//  EchoPopController.h
//  HYEcho
//
//  Created by AiDong on 15/11/13.
//  Copyright © 2015年 AiDong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EchoPopController ;

@protocol EchoPopControllerDelegate <NSObject>

-(void)dismissViewController:(EchoPopController *)mcv;

@end

@interface EchoPopController : UIViewController<UIViewControllerTransitioningDelegate>

@property (nonatomic, weak) id<EchoPopControllerDelegate>delegate ;

@end
