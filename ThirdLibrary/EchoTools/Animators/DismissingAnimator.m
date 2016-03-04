//
//  DismissingAnimator.m
//  Masonry_cpmplexCellDemo
//
//  Created by huyang on 15/6/19.
//  Copyright (c) 2015年 huyang. All rights reserved.
//

#import "DismissingAnimator.h"
//#import "POP.h"


@implementation DismissingAnimator

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
    
//    //这个动画的效果是使下面平铺的那个dimmingView变透明,造成从屏幕消失的视觉效果
//    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
//    opacityAnimation.toValue = @(0.0);
//    
//    //这个动画效果是改变present出来的modalView的消失方式
//    POPBasicAnimation *offScreenAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
//    // toValue 设为负数的话,则从当前位置往屏幕上方移动消失
//    // toValue 设为正数的话,则从当前位置往屏幕下方移动消失
////    offScreenAnimation.toValue = @(2*fromVC.view.layer.position.y);
//    offScreenAnimation.toValue = @(-fromVC.view.layer.position.y);
//    [offScreenAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
//        [transitionContext completeTransition:YES];
//    }];
//    
////    //这个动画效果是改变present出来的modalView的消失方式
////    POPBasicAnimation *offScreenAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
////    // toValue 设为CGPointZero的话,则从当前大小慢慢变小直至消失
////    offScreenAnimation.toValue = [NSValue valueWithCGPoint:CGPointZero];
////    [offScreenAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
////        [transitionContext completeTransition:YES];
////    }];
//    
//    [fromVC.view.layer pop_addAnimation:offScreenAnimation forKey:@"offScreenAnimation"];
//    [dimmingView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
}

@end


























