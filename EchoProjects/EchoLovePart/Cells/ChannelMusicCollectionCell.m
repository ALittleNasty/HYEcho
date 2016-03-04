//
//  ChannelMusicCollectionCell.m
//  HYEcho
//
//  Created by AiDong on 15/11/10.
//  Copyright © 2015年 AiDong. All rights reserved.
//

#import "ChannelMusicCollectionCell.h"

@interface ChannelMusicCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *customImage;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLable;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation ChannelMusicCollectionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(ChannelMusicModel *)model
{
    _model = model ;
    [self.customImage sd_setImageWithURL:[NSURL URLWithString:_model.pic_200] placeholderImage:nil];
    self.likeCountLable.text = _model.like_count ;
    self.nameLabel.text = _model.name ;
    self.userNameLabel.text = _model.user.name ;
}



@end
