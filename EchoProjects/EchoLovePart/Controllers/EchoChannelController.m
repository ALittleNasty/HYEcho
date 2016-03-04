//
//  EchoChannelController.m
//  HYEcho
//
//  Created by AiDong on 15/11/9.
//  Copyright © 2015年 AiDong. All rights reserved.
//

#import "EchoChannelController.h"
#import "EchoPlayMusicController.h"

#import "ChannelBannerCollectionCell.h"
#import "ChannelMusicCollectionCell.h"
#import "ChannelMusicModel.h"

static NSString *bannerReuseID = @"ChannelBannerCellID";
static NSString *musicReuseID = @"ChannelMusicCellID";
@interface EchoChannelController ()<UICollectionViewDataSource,
                                    UICollectionViewDelegate,
                                    UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView ;
@property (nonatomic,   copy) NSString         *urlString ;

@end

@implementation EchoChannelController

// 初始化数据
- (instancetype)init
{
    self = [super init];
    if (self) {
        //初始化解析数据
        [DataManager shareDataManager].currentIndex++ ;
        
        self.urlString = [DataManager shareDataManager].urlTypeString ;
        
        NSData *data = nil ;
        NSArray *array = nil ;
        
        if ([self.urlString isEqualToString:HomePage_URL]) {
            data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[self.urlString stringByAppendingFormat:@"%ld",[DataManager shareDataManager].currentIndex]]];
            if (!data) {
                return self;
            }
            array = [[[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil] valueForKey:@"result"] valueForKey:@"data"];
        }else{
            data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[self.urlString stringByAppendingFormat:@"%ld&limit=20",[DataManager shareDataManager].currentIndex]]];
            if (!data) {
                return self;
            }
            array = [[[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil] valueForKey:@"result"] valueForKey:@"data"];
        }
        
        if (data == nil) {
            return self ;
        }
        
        NSArray *musics = [ChannelMusicModel objectArrayWithKeyValuesArray:array] ;
        [[DataManager shareDataManager].arrayData addObjectsFromArray:musics];
    }
    return self ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initCollectionView];
    
    [self requestDataWithUrlString:_urlString];
}

- (void)initCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self ;
    _collectionView.dataSource = self ;
    [self.view addSubview:_collectionView];
    [_collectionView registerNib:[ChannelBannerCollectionCell nib] forCellWithReuseIdentifier:bannerReuseID];
    [_collectionView registerNib:[ChannelMusicCollectionCell nib] forCellWithReuseIdentifier:musicReuseID];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsZero) ;
    }];
    
    __weak EchoChannelController *weakself = self ;
    //下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [DataManager shareDataManager].currentIndex = 0 ;
        [DataManager shareDataManager].arrayData = nil ;
        [weakself requestDataWithUrlString:weakself.urlString];
    }];
    
    //上拉加载更多
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [DataManager shareDataManager].currentIndex ++ ;
        [weakself requestDataWithUrlString:weakself.urlString];
    }];
    
    self.collectionView.header = header ;
    self.collectionView.footer = footer ;
}

#pragma mark --- collectionView Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2 ;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1 ;
    }
    
    return [DataManager shareDataManager].arrayData.count ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil ;
    if (indexPath.section == 0) {
        ChannelBannerCollectionCell *bannerCell = [collectionView dequeueReusableCellWithReuseIdentifier:bannerReuseID forIndexPath:indexPath] ;
        cell = bannerCell ;
    }else{
        ChannelMusicCollectionCell *musicCell = [collectionView dequeueReusableCellWithReuseIdentifier:musicReuseID forIndexPath:indexPath] ;
        if ([DataManager shareDataManager].arrayData.count > 0) {
            ChannelMusicModel *model = [[DataManager shareDataManager].arrayData objectAtIndex:indexPath.item] ;
            musicCell.model = model;
        }
        cell = musicCell ;
    }
    return cell ;
}

//最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return 0.f ;
    }
    return 5.f ;
}
//最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return 0.f ;
    }
    return 5.f ;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CGSize size = [UIScreen mainScreen].bounds.size;
        return CGSizeMake(size.width, size.height/4);
    }
    CGFloat itemWidth = (kFullWidth-25.f)/2 ;
    return CGSizeMake(itemWidth,itemWidth+40.f);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return UIEdgeInsetsMake(0.f, 0.f, 5.f, 0.f);
    }
    return UIEdgeInsetsMake(5.f, 10.f, 5.f, 10.f) ;
}

#pragma mark --- collectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    EchoPlayMusicController *playVC = [EchoPlayMusicController shareEchoPlayViewController];
    playVC.isLocal = NO ;
    playVC.index = indexPath.item ;
    [self.navigationController pushViewController:playVC animated:YES];
}

#pragma mark --- 从服务器请求数据
- (void)requestDataWithUrlString:(NSString *)string
{
    [self.view showLoadingView];
    __weak EchoChannelController *weakself = self ;
//    [DataManager shareDataManager].currentIndex ++;
    NSString *url = nil;
    if ([string isEqualToString:HomePage_URL]) {
        url = [string stringByAppendingFormat:@"%ld",[DataManager shareDataManager].currentIndex];
    }
    else{
        url = [string stringByAppendingFormat:@"%ld&limit=20",[DataManager shareDataManager].currentIndex];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [weakself.view hideLoadingImmediately];
        
        //这里解析方式不同！！要统一需要判断
        NSArray *array = nil;
        if ([string isEqualToString:HomePage_URL]) {
            array = [[responseObject valueForKey:@"result"] valueForKey:@"data"];
        }
        else{
            array = [[[responseObject valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"sounds"];
        }
        
        NSArray *musics = [ChannelMusicModel objectArrayWithKeyValuesArray:array] ;
        [[DataManager shareDataManager].arrayData addObjectsFromArray:musics];
//        NSLog(@"%ld",[DataManager shareDataManager].arrayData.count);
        
        [weakself.collectionView.header endRefreshing];
        [weakself.collectionView.footer endRefreshing];
        [weakself.collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [weakself.view hideLoadingImmediately];
        NSLog(@"%@",error);
    }];
}

@end
