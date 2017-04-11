//
//  AProcess3HistoryCell.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/4/11.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "AProcess3HistoryCell.h"

@interface AProcess3HistoryCell ()

@property (weak, nonatomic) IBOutlet UIButton *btnDetail;

@end

@implementation AProcess3HistoryCell

+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"AProcess3HistoryCell" owner:nil options:nil];
    
    if (0 == array.count) {
        return nil;
    }
    
    return array[0];
}

+ (NSString *)identifier
{
    return @"a_process3_history_cell";
}

+ (CGFloat)cellHeight
{
    return 88;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _btnDetail.layer.masksToBounds = YES;
    _btnDetail.layer.cornerRadius = 12;
    
    [_btnDetail addTarget:self action:@selector(onClickDetail) forControlEvents:UIControlEventTouchUpInside];
}


- (void)onClickDetail
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickDetail)]) {
        [_delegate onClickDetail];
    }
}

@end
