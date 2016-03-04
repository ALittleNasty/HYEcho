//
//  PresentingAnimatorZoom.m
//  Masonry_cpmplexCellDemo
//
//  Created by huyang on 15/6/23.
//  Copyright (c) 2015年 huyang. All rights reserved.
//

#import "PresentingAnimatorZoom.h"


@implementation PresentingAnimatorZoom


- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5f ;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view ;
    fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed ;
    fromView.userInteractionEnabled = NO ;
    
    // toView 下面平铺的一层背景view,先设为透明,颜色改为自定义灰色偏暗
    UIView *dimmingView = [[UIView alloc] initWithFrame:fromView.bounds] ;
    dimmingView.backgroundColor = EchoColor(84, 84, 84);
    dimmingView.layer.opacity = 0.0 ;
    
    UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view ;
    //设置present出来的那个modalView的大小
    toView.frame = CGRectMake(0.f, 0.f, kFullWidth-100.f, 200.f) ;
    
    //中心点与屏幕中心重合
    toView.center = CGPointMake(transitionContext.containerView.center.x,
                                transitionContext.containerView.center.y) ;
    
    [transitionContext.containerView addSubview:dimmingView];
    [transitionContext.containerView addSubview:toView];
    
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = 0.2 ;
    opacityAnimation.toValue = @(0.2) ;
    
    CABasicAnimation *zoomAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    zoomAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn] ;
    zoomAnimation.duration = 0.2 ;
    zoomAnimation.repeatCount = 0.f ;
    zoomAnimation.autoreverses = NO ;
    zoomAnimation.fromValue = @(2.5);
    zoomAnimation.toValue = @(1.0);
    zoomAnimation.removedOnCompletion = YES ;
    [toView.layer addAnimation:zoomAnimation forKey:nil];
    [dimmingView.layer addAnimation:opacityAnimation forKey:nil];
}


@end
