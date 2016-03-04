//
//  PMChannelCell.m
//  HYEcho
//
//  Created by AiDong on 15/11/11.
//  Copyright © 2015年 AiDong. All rights reserved.
//

#import "PMChannelCell.h"

@implementation PMChannelCell

- (void)awakeFromNib {
    // Initialization code
    self.customImage.layer.masksToBounds = YES ;
    self.customImage.layer.cornerRadius = 3.f ;
    self.customImage.contentMode = UIViewContentModeScaleAspectFill ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
