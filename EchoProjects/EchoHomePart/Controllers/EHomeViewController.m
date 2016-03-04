//
//  EHomeViewController.m
//  HYEcho
//
//  Created by AiDong on 15/11/9.
//  Copyright © 2015年 AiDong. All rights reserved.
//

#import "EHomeViewController.h"
#import "EchoPopController.h"

#import "PresentingAnimatorZoom.h"
#import "DismissingAnimatorZoom.h"

@interface EHomeViewController ()<EchoPopControllerDelegate>

@end

@implementation EHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    EchoPopController *popVC = [[EchoPopController alloc] init];
    popVC.delegate = self ;
//    popVC.modalPresentationStyle = UIModalPresentationCustom ;
    popVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve ;
    [self.navigationController presentViewController:popVC animated:YES completion:nil];
}

- (void)dismissViewController:(EchoPopController *)mcv
{
    [mcv dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --- UIViewControllerTransitioningDelegate

//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
//                                                                  presentingController:(UIViewController *)presenting
//                                                                      sourceController:(UIViewController *)source
//{
//    // 概括来说，new和alloc/init在功能上几乎是一致的，分配内存并完成初始化。
//    // 差别在于，采用new的方式只能采用默认的init方法完成初始化，
//    // 采用alloc的方式可以用其他定制的初始化方法。例如NSMutableArray 的 [[NSMutableArray alloc] initWithArray:...];
//    
//    return [[PresentingAnimatorZoom alloc] init];
//}
//
//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
//{
//    return [[DismissingAnimatorZoom alloc] init];
//}

@end
