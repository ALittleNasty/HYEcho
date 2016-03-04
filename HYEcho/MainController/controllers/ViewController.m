//
//  ViewController.m
//  HYEcho
//
//  Created by AiDong on 15/11/6.
//  Copyright © 2015年 AiDong. All rights reserved.
//

#import "ViewController.h"
#import "EchoNavigationController.h" //自定义导航栏
#import "EHomeViewController.h" //首页
#import "ELoveViewController.h" //最爱
#import "EFindViewController.h" //发现
#import "EMineViewController.h" //我的

@interface ViewController ()<UITabBarControllerDelegate>

@end

@implementation ViewController

//-(void)viewDidAppear:(BOOL)animated{
//    self.hidesBottomBarWhenPushed=YES;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *normalImages = @[[UIImage imageNamed:@"tab_home_normal"],
                              [UIImage imageNamed:@"tab_assistant_normal"],
                              [UIImage imageNamed:@"tab_find_normal"],
                              [UIImage imageNamed:@"tab_mine_normal"]];
    
    NSArray *selectImages = @[[UIImage imageNamed:@"tab_home_focus"],
                              [UIImage imageNamed:@"tab_assistant_focus"],
                              [UIImage imageNamed:@"tab_find_focus"],
                              [UIImage imageNamed:@"tab_mine_focus"]];
    
    NSArray *classNames = @[NSStringFromClass([EHomeViewController class]),
                            NSStringFromClass([ELoveViewController class]),
                            NSStringFromClass([EFindViewController class]) ,
                            NSStringFromClass([EMineViewController class])];
    
    NSArray *titleArray = @[@"首页",@"最爱",@"发现",@"我的"];
    
    self.viewControllers = [self customTabBarControllerWithControllers:classNames
                                                                titles:titleArray
                                                        selectedImages:selectImages
                                                          normalImages:normalImages];
    
    self.selectedIndex = 0 ;
    self.hidesBottomBarWhenPushed = YES ;
    
    UIImage *whiteImage = [self imageWithColor:[UIColor whiteColor]] ;
    self.tabBar.backgroundImage = whiteImage ;
    self.delegate = self ;
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.f, 1.f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (NSArray *)customTabBarControllerWithControllers:(NSArray *)classNames titles:(NSArray *)titles selectedImages:(NSArray *)selectedImages normalImages:(NSArray *)normalImages
{
    NSMutableArray *controllers = [[NSMutableArray alloc] initWithCapacity:classNames.count];
    
    for (int i = 0; i < classNames.count; i++)
    {
        NSString *className = classNames[i] ;
        NSString *title = titles[i] ;
        UIImage *normalImage = normalImages[i] ;
        UIImage *selectedImage = selectedImages[i] ;
        
        UIViewController *vc = [[NSClassFromString(className) alloc] init];
        vc.tabBarItem.title = title ;
        [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: EchoColor(110, 110, 110)} forState:UIControlStateNormal];
        [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: EchoTintColor} forState:UIControlStateSelected];
        
        vc.tabBarItem.image = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] ;
        vc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] ;
        
        EchoNavigationController *ENavi = [[EchoNavigationController alloc] initWithRootViewController:vc] ;
        [controllers addObject:ENavi];
    }
    
    return controllers ;
}

//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
//{
//    if ([viewController isKindOfClass:[EchoNavigationController class]]) {
//        EchoNavigationController *dispatcher = (EchoNavigationController*)viewController;
//        if ([dispatcher.viewControllers count] > 1) {
//            [dispatcher popToRootViewControllerAnimated:NO];
//        }
//    }
//}


@end
