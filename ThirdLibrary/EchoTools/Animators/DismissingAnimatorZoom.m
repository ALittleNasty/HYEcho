//
//  DismissingAnimatorZoom.m
//  Masonry_cpmplexCellDemo
//
//  Created by huyang on 15/6/23.
//  Copyright (c) 2015年 huyang. All rights reserved.
//

#import "DismissingAnimatorZoom.h"
#import <QuartzCore/QuartzCore.h>

@implementation DismissingAnimatorZoom

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5f ;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.view.tintAdjustmentMode = UIViewTintAdjustmentModeNormal ;
    toVC.view.userInteractionEnabled = YES ;
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    __block UIView *dimmingView ;
    [transitionContext.containerView.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        
        if (view.layer.opacity < 1.f) {
            dimmingView = view;
            *stop = YES ;
        }
    }];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = 0.5 ;
    opacityAnimation.toValue = @(0.0) ;
    
    CABasicAnimation *zoomAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    zoomAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn] ;
    zoomAnimation.duration = 0.5 ;
    zoomAnimation.repeatCount = 1.f ;
    zoomAnimation.autoreverses = YES ;
    zoomAnimation.fromValue = @(1.0);
    zoomAnimation.toValue = @(0.0);
    
    [fromVC.view.layer addAnimation:zoomAnimation forKey:nil];
    [dimmingView.layer addAnimation:opacityAnimation forKey:nil];
}

@end
