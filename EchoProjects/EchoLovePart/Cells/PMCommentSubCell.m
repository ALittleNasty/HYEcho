//
//  PMCommentSubCell.m
//  HYEcho
//
//  Created by AiDong on 15/11/11.
//  Copyright © 2015年 AiDong. All rights reserved.
//

#import "PMCommentSubCell.h"

@interface PMCommentSubCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatorImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeightConstraint;


@end

@implementation PMCommentSubCell

- (void)awakeFromNib {
    // Initialization code
    self.lineHeightConstraint.constant = 0.5f ;
    self.avatorImage.layer.masksToBounds = YES ;
    self.avatorImage.layer.cornerRadius = 20.f ;
    self.timeLabel.textColor = EchoColor(74, 255, 68);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(Comment *)model
{
    _model = model ;
    [self.avatorImage sd_setImageWithURL:[NSURL URLWithString:_model.user.avatar_50] placeholderImage:nil];
    self.userNameLabel.text = _model.user.name ;
    self.contentLabel.text = _model.original_content ;
    self.countLabel.text = _model.like ;
    
    NSDate *deadlineDate = [NSDate dateWithTimeIntervalSince1970:_model.create_time.doubleValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd:HH:mm:ss"];
    NSDate *nowDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int unitFlags =  NSCalendarUnitMonth |
                              NSCalendarUnitDay |
                              NSCalendarUnitHour |
                              NSCalendarUnitMinute |
                              NSCalendarUnitSecond;
    NSDateComponents *component = [calendar components:unitFlags fromDate:nowDate toDate:deadlineDate options:0];//计算时间差

    NSString *timeString = nil ;
    if ([component month] > 0) {
        timeString = [NSString stringWithFormat:@"%ld个月前",[component month]] ;
    }else{
        if ([component day] > 0) {
            timeString = [NSString stringWithFormat:@"%ld天前",[component day]] ;
        }else{
            if ([component hour] > 0) {
                timeString = [NSString stringWithFormat:@"%ld小时前",[component hour]] ;
            }else{
                if ([component minute] > 0) {
                    timeString = [NSString stringWithFormat:@"%ld分钟前",[component minute]] ;
                }else{
                    timeString = [NSString stringWithFormat:@"%ld秒前",[component second]] ;
                }
            }
        }
    }
    self.timeLabel.text = timeString ;
      
}

@end
