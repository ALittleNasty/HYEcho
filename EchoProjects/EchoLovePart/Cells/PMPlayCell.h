//
//  PMPlayCell.h
//  HYEcho
//
//  Created by AiDong on 15/11/11.
//  Copyright © 2015年 AiDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PMPlayCellDelegate <NSObject>

- (void)playButtonClicked:(UIButton *)btn ;
- (void)focusButtonClicked:(UIButton *)btn ;
- (void)tapImageToPauseMusic ;

@end


@interface PMPlayCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatorImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *focusLabel;
@property (weak, nonatomic) IBOutlet UIButton *focusButton;
@property (weak, nonatomic) IBOutlet UIImageView *cuctomImage;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIView *blackView;
@property (weak, nonatomic) IBOutlet UILabel *payTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *soundNameLabel;
@property (weak, nonatomic) IBOutlet UIView *progressBarView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressConstraint;


@property (nonatomic,   weak) id<PMPlayCellDelegate>delegate ;

@end
