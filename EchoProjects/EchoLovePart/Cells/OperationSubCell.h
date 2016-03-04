//
//  OperationSubCell.h
//  HYEcho
//
//  Created by AiDong on 15/11/11.
//  Copyright © 2015年 AiDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OperationSubCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *customImage;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineWidthConstraint;


@property (nonatomic, assign) BOOL  hideRightLine ;

@end
