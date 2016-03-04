//
//  ELSettingViewController.m
//  HYEcho
//
//  Created by AiDong on 15/11/9.
//  Copyright © 2015年 AiDong. All rights reserved.
//

#import "ELSettingViewController.h"
#import "loveSettingLogoCell.h"
#import "loveSettingCacheCell.h"

static NSString *logoCellReuseID = @"LSettingLogoCell";
static NSString *cacheCellReuseID = @"LSettingCacheCell";

@interface ELSettingViewController ()<UITableViewDataSource,
                                      UITableViewDelegate,
                                      UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView ;

@end

@implementation ELSettingViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置" ;
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self ;
    _tableView.dataSource = self ;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsZero) ;
    }];
    [_tableView registerNib:[loveSettingLogoCell nib] forCellReuseIdentifier:logoCellReuseID];
    [_tableView registerNib:[loveSettingCacheCell nib] forCellReuseIdentifier:cacheCellReuseID];
    
    self.navigationController.hidesBottomBarWhenPushed = YES ;
}

#pragma mark --- tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2 ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 200.f ;
    }else{
        return 60.f ;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil ;
    
    if (indexPath.row == 0) {
        loveSettingLogoCell *logoCell = [tableView dequeueReusableCellWithIdentifier:logoCellReuseID forIndexPath:indexPath] ;
        cell = logoCell ;
    }else{
        loveSettingCacheCell *cacheCell = [tableView dequeueReusableCellWithIdentifier:cacheCellReuseID forIndexPath:indexPath] ;
        cell = cacheCell ;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    return cell ;
}

#pragma mark --- tableview datasource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
//        NSInteger fileCount = [[SDImageCache sharedImageCache] getDiskCount];
//        NSInteger memoryRoom = [[SDImageCache sharedImageCache] getSize]/(1024*1024) ;
//        NSString *msg = [NSString stringWithFormat:@"共有%ld个文件,共占用%ldM内存",fileCount,memoryRoom];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alert show];
        
        
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [self.view showAlertTextWith:@"清理完成"];
            [self.tableView reloadData];
        }];
    }
}



@end
