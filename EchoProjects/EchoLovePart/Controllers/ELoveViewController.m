//
//  ELoveViewController.m
//  HYEcho
//
//  Created by AiDong on 15/11/9.
//  Copyright © 2015年 AiDong. All rights reserved.
//

#import "ELoveViewController.h"
#import "EchoChannelController.h"
#import "ELSettingViewController.h"
#import "LoveCollectionCell.h"
#import "LoveCollectionModel.h"

@interface ELoveViewController ()<UICollectionViewDataSource,
                                  UICollectionViewDelegate,
                                  UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UISegmentedControl *segmentControl ;
@property (nonatomic, strong) UICollectionView   *collectionView ;
@property (nonatomic,   copy) NSString           *urlTypeString ;
@property (nonatomic, assign) NSInteger          indexHot ;
@property (nonatomic, assign) NSInteger          indexNew ;
@property (nonatomic, strong) NSMutableArray     *arrayHot ;
@property (nonatomic, strong) NSMutableArray     *arrayNew ;

@end

static NSString *cellReuseID = @"loveCellID" ;
@implementation ELoveViewController

#pragma mark --- viewController lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _urlTypeString = HOT ;
    _indexHot = 1 ;
    _indexNew = 1 ;
    _arrayHot = [NSMutableArray array] ;
    _arrayNew = [NSMutableArray array] ;
    
    [self setUpNavigationBarItems];
    
    [self initSubviews];
    
    [self requestDataFromServerWithUrlString:_urlTypeString andCurrentIndex:_indexHot];
}

#pragma mark --- segmentControl init&event
- (void)setUpNavigationBarItems
{
    _segmentControl = [[UISegmentedControl alloc] init];
    _segmentControl.tag = 10000 ;
    _segmentControl.frame = CGRectMake((kFullWidth-200.f)/2, 5.f, 200.f, 30.f) ;
    _segmentControl.backgroundColor = [UIColor clearColor];
    _segmentControl.layer.masksToBounds = YES ;
    _segmentControl.layer.cornerRadius = 5.f ;
    _segmentControl.layer.borderWidth = 1.f ;
    _segmentControl.layer.borderColor = [UIColor whiteColor].CGColor ;
    [_segmentControl insertSegmentWithTitle:@"最热" atIndex:0 animated:NO];
    [_segmentControl insertSegmentWithTitle:@"最新" atIndex:1 animated:NO];
    _segmentControl.selectedSegmentIndex = 0 ;
    [_segmentControl setTintColor:[UIColor whiteColor]];
    [_segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
    [_segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName: EchoTintColor } forState:UIControlStateSelected];
    [_segmentControl addTarget:self action:@selector(segmentControlAction:) forControlEvents:UIControlEventValueChanged] ;
    self.navigationItem.titleView = _segmentControl;
    
    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(settingItemAction:)];
    self.navigationItem.rightBarButtonItem = settingItem ;
}
- (void)segmentControlAction:(UISegmentedControl *)seg
{
    if (seg.selectedSegmentIndex == 0) {
        _urlTypeString = HOT ;
        
        if (_arrayHot.count > 0) {
            [self.collectionView reloadData];
        }else{
            [self requestDataFromServerWithUrlString:_urlTypeString andCurrentIndex:_indexHot];
        }
        
    }else if (seg.selectedSegmentIndex == 1){
        _urlTypeString = NEW ;
        
        if (_arrayNew.count > 0) {
            [self.collectionView reloadData];
        }else{
            [self requestDataFromServerWithUrlString:_urlTypeString andCurrentIndex:_indexNew];
        }
    }
}

- (void)settingItemAction:(UIBarButtonItem *)item
{
    ELSettingViewController *settingVC = [[ELSettingViewController alloc] init];
    settingVC.hidesBottomBarWhenPushed = YES ;
    [self.navigationController pushViewController:settingVC animated:YES];
}

#pragma mark --- init subviews

- (void)initSubviews
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 5.f ;
    layout.minimumLineSpacing = 5.f ;
    layout.sectionInset = UIEdgeInsetsMake(5.f, 5.f, 5.f, 5.f) ;
    
    CGFloat itemWidth = (kFullWidth-5.f-5.f-5.f)/2 ;
    layout.itemSize = CGSizeMake(itemWidth, itemWidth*0.7) ;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.delegate = self ;
    _collectionView.dataSource = self ;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    [_collectionView registerNib:[LoveCollectionCell nib] forCellWithReuseIdentifier:cellReuseID];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f)) ;
    }];
    
    __weak ELoveViewController *weakself = self ;
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakself requestMoreDataWithURL:weakself.urlTypeString];
    }];
    
    footer.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray ;
    footer.stateLabel.hidden = YES ;
    self.collectionView.footer = footer ;
}

#pragma mark --- collectionView datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1 ;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_segmentControl.selectedSegmentIndex == 0) {
        return _arrayHot.count > 0 ? _arrayHot.count : 0 ;
    }else{
        return _arrayNew.count > 0 ? _arrayNew.count : 0 ;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LoveCollectionCell *loveCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseID forIndexPath:indexPath] ;
    
    if (_segmentControl.selectedSegmentIndex == 0) {
        LoveCollectionModel *model = _arrayHot[indexPath.item] ;
        loveCell.model = model ;
    }else{
        LoveCollectionModel *model = _arrayNew[indexPath.item] ;
        loveCell.model = model ;
    }
    
    return loveCell ;
}
#pragma mark --- collectionView delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //
    NSString *urlStr = nil ;
    NSString *channelTitle = nil ;
    if (_segmentControl.selectedSegmentIndex == 0) {
        LoveCollectionModel *model = _arrayHot[indexPath.item] ;
        urlStr = [NSString stringWithFormat:@"http://echosystem.kibey.com/channel/info?list_order=%@&id=%@&page=",@"hot",model.ID] ;
        channelTitle = model.name ;
    }else{
        LoveCollectionModel *model = _arrayNew[indexPath.item] ;
        urlStr = [NSString stringWithFormat:@"http://echosystem.kibey.com/channel/info?list_order=%@&id=%@&page=",@"new",model.ID] ;
        channelTitle = model.name ;
    }
    
    if (![urlStr isEqualToString:[DataManager shareDataManager].urlTypeString]) {
        [DataManager shareDataManager].urlTypeString = urlStr ;
        [DataManager shareDataManager].arrayData = nil ;
        [DataManager shareDataManager].currentIndex = 0 ;
    }
        
    EchoChannelController *channelVC = [[EchoChannelController alloc] init];
    channelVC.hidesBottomBarWhenPushed = YES ;
    channelVC.title = channelTitle ;
    [self.navigationController pushViewController:channelVC animated:YES];
}
#pragma mark --- 上拉加载更多数据
- (void)requestMoreDataWithURL:(NSString *)urlString
{
    if (_segmentControl.selectedSegmentIndex == 0) {
        _indexHot ++ ;
        [self requestDataFromServerWithUrlString:_urlTypeString andCurrentIndex:_indexHot];
    }else{
        _indexNew ++ ;
        [self requestDataFromServerWithUrlString:_urlTypeString andCurrentIndex:_indexNew];
    }
}

#pragma mark --- 从服务器请求数据
- (void)requestDataFromServerWithUrlString:(NSString *)urlString andCurrentIndex:(NSInteger)index
{
    [self.view showLoadingView];
    NSString *url = [Channel_URL stringByAppendingFormat:@"%ld%@",index,urlString] ;
    __weak ELoveViewController *weakself = self ;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager] ;

    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [weakself.view hideLoadingImmediately];
        [[weakself.collectionView footer] endRefreshing];
        
        NSDictionary *rootDic = (NSDictionary *)responseObject[@"result"];
        NSArray *array = [LoveCollectionModel objectArrayWithKeyValuesArray:rootDic[@"data"]] ;
        
        
        if (weakself.segmentControl.selectedSegmentIndex == 0) {
            [weakself.arrayHot addObjectsFromArray:array];
        }else{
            [weakself.arrayNew addObjectsFromArray:array];
        }
        
        [weakself.collectionView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [weakself.view hideLoadingImmediately];
        [[weakself.collectionView footer] endRefreshing];
        NSLog(@"--error:%@--",error) ;
    }] ;
}

@end
