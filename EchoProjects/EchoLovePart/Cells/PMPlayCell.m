//
//  PMPlayCell.m
//  HYEcho
//
//  Created by AiDong on 15/11/11.
//  Copyright © 2015年 AiDong. All rights reserved.
//

#import "PMPlayCell.h"

@interface PMPlayCell ()




@end

@implementation PMPlayCell

- (void)awakeFromNib {
    // Initialization code
    self.avatorImage.layer.masksToBounds = YES ;
    self.avatorImage.layer.cornerRadius = 20.f ;
    
    self.playButton.layer.masksToBounds = YES ;
    self.playButton.layer.cornerRadius = 5.f ;
    self.playButton.hidden = YES ;
    
    self.cuctomImage.userInteractionEnabled = YES ;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.cuctomImage addGestureRecognizer:tap];
    
    self.blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.progressBarView.backgroundColor = [EchoColor(74, 255, 68) colorWithAlphaComponent:0.5] ;
    self.progressConstraint.constant = 100.f ;
    
    self.cuctomImage.contentMode = UIViewContentModeScaleAspectFit ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(tapImageToPauseMusic)]) {
        
        if (self.playButton.hidden == YES) {
            self.playButton.hidden = NO ;
            [self.delegate tapImageToPauseMusic];
        }
    }
}

- (IBAction)playButtonAction:(id)sender
{
    self.playButton.hidden = YES ;
    
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(playButtonClicked:)])
    {
        [self.delegate playButtonClicked:self.playButton];
    }
}
- (IBAction)focusButtonAction:(id)sender
{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(focusButtonClicked:)])
    {
        [self.delegate focusButtonClicked:self.focusButton];
    }
}

@end
