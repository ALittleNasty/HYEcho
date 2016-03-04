//
//  EchoBaseViewController.m
//  HYEcho
//
//  Created by AiDong on 15/11/9.
//  Copyright © 2015年 AiDong. All rights reserved.
//

#import "EchoBaseViewController.h"

@interface EchoBaseViewController ()

@end

@implementation EchoBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backItemAction:)];
    self.navigationItem.leftBarButtonItem = backItem ;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backItemAction:(UIBarButtonItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backItemClickWithCompleteBlock:(BackBlock)block
{
    block(nil) ;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
