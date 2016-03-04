//
//  PMOperationCell.h
//  HYEcho
//
//  Created by AiDong on 15/11/11.
//  Copyright © 2015年 AiDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PMOperationCellDelegate <NSObject>

- (void)operationAtIndex:(NSInteger)index ;

@end

@interface PMOperationCell : UITableViewCell

@property (nonatomic, weak) id<PMOperationCellDelegate>delegate ;

@end
