//
//  loveSettingLogoCell.m
//  HYEcho
//
//  Created by AiDong on 15/11/9.
//  Copyright © 2015年 AiDong. All rights reserved.
//

#import "loveSettingLogoCell.h"

@interface loveSettingLogoCell ()

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;


@end

@implementation loveSettingLogoCell

- (void)awakeFromNib {
    // Initialization code
    
    _versionLabel.textColor = EchoTintColor ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
