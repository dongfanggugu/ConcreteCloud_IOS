//
//  SupOrderDisCell.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/14.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupOrderDisCell.h"

@interface SupOrderDisCell()

@property (weak, nonatomic) IBOutlet UIImageView *ivProcess;

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

@end

@implementation SupOrderDisCell

+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SupOrderDisCell" owner:nil options:nil];
    
    if (0 == array.count)
    {
        return nil;
    }
    
    return array[0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _btnDis.layer.masksToBounds = YES;
    _btnDis.layer.cornerRadius = 5;
    
    [_btnDis addTarget:self action:@selector(clickDispatch) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickDispatch
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickDispatch)])
    {
        [_delegate onClickDispatch];
    }
}

+ (NSString *)identifier
{
    return @"sup_order_dis_cell";
}

+ (CGFloat)cellHeight
{
    return 90;
}


- (void)setFutureMode
{
    _ivProcess.image = [UIImage imageNamed:@"order_track_future"];
    _lbTitle.textColor = [UIColor grayColor];
    _lbDate.hidden = YES;
    _btnDis.hidden = NO;
    _btnDis.enabled = NO;
    _btnDis.backgroundColor = [UIColor grayColor];
    
}

- (void)setCurrentMode
{
    _ivProcess.image = [UIImage imageNamed:@"order_track_current"];
    _lbTitle.textColor = [Utils getColorByRGB:TITLE_COLOR];
    _lbDate.hidden = NO;
    _btnDis.hidden = NO;
    
    _btnDis.enabled = YES;
    _btnDis.backgroundColor = [Utils getColorByRGB:TITLE_COLOR];
}

- (void)setPassMode
{
    _ivProcess.image = [UIImage imageNamed:@"order_track_pass"];
    _lbTitle.textColor = [Utils getColorByRGB:TITLE_COLOR];
    _lbDate.hidden = NO;
    _btnDis.hidden = NO;
    
    _btnDis.enabled = YES;
    _btnDis.backgroundColor = [Utils getColorByRGB:TITLE_COLOR];
}

@end
