//
//  loveSettingCacheCell.m
//  HYEcho
//
//  Created by AiDong on 15/11/9.
//  Copyright © 2015年 AiDong. All rights reserved.
//

#import "loveSettingCacheCell.h"

@interface loveSettingCacheCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation loveSettingCacheCell

- (void)awakeFromNib {
    // Initialization code
    self.titleLabel.layer.masksToBounds = YES ;
    self.titleLabel.layer.cornerRadius = 5.f ;
    self.titleLabel.backgroundColor = EchoColor(255, 108, 148) ;
    self.titleLabel.textColor = [UIColor whiteColor] ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
