//
//  ChannelBannerCollectionCell.m
//  HYEcho
//
//  Created by AiDong on 15/11/10.
//  Copyright © 2015年 AiDong. All rights reserved.
//

#import "ChannelBannerCollectionCell.h"
#import "SDCycleScrollView.h"
#import "Banner.h"

@interface ChannelBannerCollectionCell ()

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView ;
@property (nonatomic, strong) NSMutableArray *allUrls;
@property (nonatomic, strong) NSMutableArray *allArrayBanner;

@end

@implementation ChannelBannerCollectionCell

- (void)awakeFromNib {
    // Initialization code
    
    [self requestBannerDataFromServer];
}

- (void)requestBannerDataFromServer
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:[Banner_URL stringByAppendingString:@""] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        NSArray *array = [responseObject valueForKey:@"result"];
        NSArray *banners = [Banner objectArrayWithKeyValuesArray:array] ;
        NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:banners.count];
        for (Banner *ban in banners) {
            NSString *imageUrl = ban.pic ;
            [images addObject:imageUrl];
        }
        
        SDCycleScrollView *customScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.frame.size.height) imageURLStringsGroup:images];
        
        customScrollView.autoScrollTimeInterval = 4.0;
        customScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        customScrollView.dotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        customScrollView.autoScroll = YES;
        customScrollView.infiniteLoop = YES;
        customScrollView.imageURLStringsGroup = images;
        [self.bottomView addSubview:customScrollView];
        self.cycleScrollView = customScrollView;
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

// 懒加载  RACollectionViewReorderableTripletLayout
-(NSMutableArray *)allUrls
{
    if (!_allUrls) {
        _allUrls = [NSMutableArray array];
    }
    return _allUrls;
}
-(NSMutableArray *)allArrayBanner
{
    if (!_allArrayBanner) {
        _allArrayBanner = [NSMutableArray array];
    }
    return _allArrayBanner;
}
@end
