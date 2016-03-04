//
//  PMChannelCell.h
//  HYEcho
//
//  Created by AiDong on 15/11/11.
//  Copyright © 2015年 AiDong. All rights reserved.
//

#import <UIKit/UIKit.h>

// height --> 95.f
@interface PMChannelCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *customImage;
@property (weak, nonatomic) IBOutlet UILabel *channelNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *channelInfoLabel;


@end
