//
//  EchoPopController.m
//  HYEcho
//
//  Created by AiDong on 15/11/13.
//  Copyright © 2015年 AiDong. All rights reserved.
//

#import "EchoPopController.h"

@interface EchoPopController ()

@property (nonatomic, strong) UIView *containorView ;

@end

@implementation EchoPopController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.layer.cornerRadius = 10.f ;
    self.view.backgroundColor = [UIColor clearColor] ;
    self.view.alpha = 0.2 ;
    
    _containorView = [[UIView alloc] init];
    _containorView.backgroundColor = EchoBlueColor ;
    _containorView.layer.masksToBounds = YES ;
    _containorView.layer.cornerRadius = 5.f ;
    
    CGFloat viewWidth = kFullWidth-100.f ;
    _containorView.frame = CGRectMake(50.f, (kFullHeight-viewWidth)/2, viewWidth, viewWidth);
    [self.view addSubview:_containorView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.delegate dismissViewController:self];
}
@end
