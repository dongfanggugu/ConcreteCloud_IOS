//
//  SupVehicleSelCell.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/15.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupVehicleSelCell.h"

@interface SupVehicleSelCell()

@end

@implementation SupVehicleSelCell

+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SupVehicleSelCell" owner:nil options:nil];
    
    if (0 == array.count)
    {
        return nil;
    }
    
    return array[0];
}

+ (NSString *)identifier
{
    return @"sup_vehicle_sel_cell";
}

+ (CGFloat)cellHeight
{
    return 66;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _swSel.on = NO;
    [_swSel addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    
    _btn.layer.masksToBounds = YES;
    _btn.layer.cornerRadius = 5;
    [_btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)change:(id)sender
{
    UISwitch *sw = (UISwitch *)sender;
    
    if (_delegate && [_delegate respondsToSelector:@selector(onChangeSwitch:)])
    {
        [_delegate onChangeSwitch:sw];
    }
}

- (void)clickBtn:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    if (_delegate && [_delegate respondsToSelector:@selector(onClickBtn:)])
    {
        [_delegate onClickBtn:btn];
    }
}

@end
