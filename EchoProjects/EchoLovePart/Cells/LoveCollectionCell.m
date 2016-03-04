//
//  LoveCollectionCell.m
//  HYEcho
//
//  Created by AiDong on 15/11/9.
//  Copyright © 2015年 AiDong. All rights reserved.
//

#import "LoveCollectionCell.h"

@interface LoveCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *customImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation LoveCollectionCell

- (void)awakeFromNib {
    // Initialization code
    
    self.layer.masksToBounds = YES ;
    self.layer.cornerRadius = 5.f ;
    self.titleLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.customImage.contentMode = UIViewContentModeScaleAspectFill ;
}

-(void)setModel:(LoveCollectionModel *)model
{
    _model = model ;
    
    [_customImage sd_setImageWithURL:[NSURL URLWithString:_model.pic_200] placeholderImage:nil];
    _titleLabel.text = _model.name ;
}

@end
