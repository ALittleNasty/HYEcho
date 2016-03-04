//
//  OperationSubCell.m
//  HYEcho
//
//  Created by AiDong on 15/11/11.
//  Copyright © 2015年 AiDong. All rights reserved.
//

#import "OperationSubCell.h"

@interface OperationSubCell ()

@property (weak, nonatomic) IBOutlet UIView *lineView;


@end

@implementation OperationSubCell

- (void)awakeFromNib {
    // Initialization code
    self.lineWidthConstraint.constant = 0.5 ;
}

-(void)setHideRightLine:(BOOL)hideRightLine
{
    _hideRightLine = hideRightLine ;
    if (_hideRightLine == YES) {
        self.lineView.hidden = YES ;
    }else{
        self.lineView.hidden = NO ;
    }
}

@end
