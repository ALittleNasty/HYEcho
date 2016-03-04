//
//  PresentingAnimator.m
//  Masonry_cpmplexCellDemo
//
//  Created by huyang on 15/6/19.
//  Copyright (c) 2015年 huyang. All rights reserved.
//

#import "PresentingAnimator.h"
//#import "POP.h"

//#define KFullWidth  [UIScreen mainScreen].bounds.size.width
//#define KFullHeight [UIScreen mainScreen].bounds.size.height
@implementation PresentingAnimator

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
    //CGRectGetWidth(transitionContext.containerView.bounds) - 100.f,
    //CGRectGetHeight(transitionContext.containerView.bounds) - 350.f
    
    //中心点与屏幕中心重合
    toView.center = CGPointMake(transitionContext.containerView.center.x,
                                transitionContext.containerView.center.y) ;
    
    [transitionContext.containerView addSubview:dimmingView];
    [transitionContext.containerView addSubview:toView];
    
//    // 这个动画效果是present出来的那个modalView的出现的方式,从屏幕上方下落直到到达屏幕中心停止
//    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
//    positionAnimation.toValue = @(transitionContext.containerView.center.y);
//    positionAnimation.springBounciness = 10.f ; //晃动幅度,值越大晃动越剧烈
//    [positionAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
//        [transitionContext completeTransition:YES];
//    }];
//    
//    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
//    scaleAnimation.springBounciness = 10.f ;
//    scaleAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(2.2, 2.4)];
//    
//    //这个动画效果是使下面平铺的dimmingview显示,由透明变为不透明(0.2)
//    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
//    opacityAnimation.toValue = @(0.2);
//    
//    [toView.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
//    [toView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
//    [dimmingView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
}

@end
