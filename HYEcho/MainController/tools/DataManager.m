//
//  DataManager.m
//  HYEcho
//
//  Created by AiDong on 15/11/10.
//  Copyright © 2015年 AiDong. All rights reserved.
//

#import "DataManager.h"
#import "Banner.h"

@interface DataManager ()

@end

@implementation DataManager
// 单例方法
+ (instancetype)shareDataManager
{
    static DataManager *manager = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DataManager alloc] init];
    });
    return manager ;
}
/**
 *  重写init方法 , 初始化数据
 */
- (instancetype)init
{
    self = [super init];
    self.urlTypeString = HomePage_URL ;
    return self ;
}
/**
 *  初始化banner
 */
- (void)initBanner
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:Banner_URL]] ;
    NSArray *array = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil] valueForKey:@"result"];
    
    for (id obj in array) {
        Banner *banner = [[Banner alloc] init];
        [banner setValuesForKeysWithDictionary:obj];
        [self.bannerArray addObject:banner];
    }
}

/**
 *  清空数据
 */
- (void)removeAllData
{
    self.arrayData = nil ;
}

//重写getter方法返回外界数据
-(NSArray *)allData
{
    return [self.arrayData copy];
}

- (CGFloat)calculateTextHeightWith:(NSString *)text andFont:(UIFont *)font andMaxWidth:(CGFloat)maxWidth
{
    if (text == nil || [text isEqualToString:@""]) {
        return 1.f ;
    }
    
    NSDictionary *dicAttribute = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] ;
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)
                                         options:NSStringDrawingUsesFontLeading|
                                                 NSStringDrawingUsesLineFragmentOrigin|
                                                 NSStringDrawingTruncatesLastVisibleLine
                                      attributes:dicAttribute
                                         context:nil];
    
    return textRect.size.height ;
}


#pragma mark -- 懒加载
- (NSMutableArray *)arrayData
{
    if (!_arrayData) {
        _arrayData = [NSMutableArray array];
    }
    return _arrayData;
}
- (NSMutableArray *)bannerArray
{
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}
- (NSMutableArray *)localURLArray
{
    if (!_localURLArray) {
        _localURLArray = [NSMutableArray array];
    }
    return _localURLArray;
}

@end
