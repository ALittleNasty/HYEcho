//
//  PMCommentCell.m
//  HYEcho
//
//  Created by AiDong on 15/11/11.
//  Copyright © 2015年 AiDong. All rights reserved.
//

#import "PMCommentCell.h"
#import "PMCommentSubCell.h"
#import "Comment.h"

static NSString *cellReuseID = @"CommentSubCellID";

@interface PMCommentCell ()<UITableViewDataSource,
                            UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *totalCountLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation PMCommentCell

- (void)awakeFromNib {
    // Initialization code
    
    self.tableView.dataSource = self ;
    self.tableView.delegate = self ;
    self.tableView.scrollEnabled = NO ;
    
    [self.tableView registerNib:[PMCommentSubCell nib] forCellReuseIdentifier:cellReuseID];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray ;
    self.totalCountLabel.text = [NSString stringWithFormat:@"评论 (%ld)",_dataArray.count] ;
    
    [self.tableView reloadData];
}

#pragma mark --- tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count > 0 ? _dataArray.count : 0 ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PMCommentSubCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseID forIndexPath:indexPath] ;
    cell.model = _dataArray[indexPath.row] ;
    return cell ;
}
@end
