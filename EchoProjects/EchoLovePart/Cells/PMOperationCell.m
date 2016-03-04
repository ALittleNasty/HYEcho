//
//  PMOperationCell.m
//  HYEcho
//
//  Created by AiDong on 15/11/11.
//  Copyright © 2015年 AiDong. All rights reserved.
//

#import "PMOperationCell.h"
#import "OperationSubCell.h"

static NSString *cellReuseID = @"OperationSubCellID";
@interface PMOperationCell ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UIView           *separatorView  ;
@property (nonatomic, strong) UICollectionView *collectionView ;
@property (nonatomic, strong) NSArray          *imageArray ;

@end

@implementation PMOperationCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ;
    if (self) {
        
        UIImage *comment = [UIImage imageNamed:@"echo_comment"] ;
        UIImage *love = [UIImage imageNamed:@"echo_love"] ;
        UIImage *download = [UIImage imageNamed:@"echo_download"] ;
        UIImage *share = [UIImage imageNamed:@"echo_share"] ;
        
        _imageArray = @[comment,love,download,share];
        
        _separatorView = [[UIView alloc] initWithFrame:CGRectZero];
        _separatorView.backgroundColor = EchoColor(229, 229, 229) ;
        [self.contentView addSubview:_separatorView];
        [_separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 45.f, 0.f)) ;
        }];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0.f ;
        layout.minimumLineSpacing = 0.f ;
        layout.sectionInset = UIEdgeInsetsZero ;
        layout.itemSize = CGSizeMake(kFullWidth/4.f, 45.f) ;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.contentView.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self ;
        _collectionView.dataSource = self ;
        _collectionView.scrollEnabled = NO ;
        [self.contentView addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(5.f, 0, 0.f, 0.f)) ;
        }];
        [_collectionView registerNib:[OperationSubCell nib] forCellWithReuseIdentifier:cellReuseID];
    }
    return  self ;
}

#pragma mark --- collection datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1 ;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4 ;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    OperationSubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseID forIndexPath:indexPath];
    
    cell.customImage.image = _imageArray[indexPath.item] ;
    cell.countLabel.text = [NSString stringWithFormat:@"%d",1000+arc4random()%100] ;
    
    if (indexPath.item == 3) {
        cell.hideRightLine = YES ;
    }else{
        cell.hideRightLine = NO ;
    }
    
    return cell ;
}

#pragma mark --- collection delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(operationAtIndex:)]) {
        [self.delegate operationAtIndex:indexPath.item];
    }
}
@end
