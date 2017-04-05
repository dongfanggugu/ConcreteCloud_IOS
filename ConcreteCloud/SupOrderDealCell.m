//
//  SupOrderDealCell.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/14.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupOrderDealCell.h"

@interface SupOrderDealCell()

@property (weak, nonatomic) IBOutlet UIImageView *ivProcess;

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

@property (weak, nonatomic) IBOutlet UIButton *btnOk;

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

@end

@implementation SupOrderDealCell

+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SupOrderDealCell" owner:nil options:nil];
    
    if (0 == array.count)
    {
        return nil;
    }
    
    return array[0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _btnOk.layer.masksToBounds = YES;
    _btnOk.layer.cornerRadius = 5;
    
    _btnCancel.layer.masksToBounds = YES;
    _btnCancel.layer.cornerRadius = 5;
    
    [_btnOk addTarget:self action:@selector(clickOk) forControlEvents:UIControlEventTouchUpInside];
    [_btnCancel addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];

}

- (void)clickOk
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickOk)])
    {
        [_delegate onClickOk];
    }
}

- (void)clickCancel
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickCancel)])
    {
        [_delegate onClickCancel];
    }
}

+ (NSString *)identifier
{
    return @"sup_order_deal_cell";
}

+ (CGFloat)cellHeight
{
    return 90;
}


- (void)setCurrentMode
{
    _ivProcess.image = [UIImage imageNamed:@"order_track_current"];
    _lbTitle.textColor = [Utils getColorByRGB:TITLE_COLOR];
    _lbDate.hidden = NO;
    _btnOk.hidden = NO;
    _btnCancel.hidden = NO;
    
    _btnOk.enabled = YES;
    _btnOk.backgroundColor = [Utils getColorByRGB:TITLE_COLOR];

    [_btnOk setTitle:@"订单确认" forState:UIControlStateNormal];
}

- (void)setPassMode:(BOOL)pass
{
    _ivProcess.image = [UIImage imageNamed:@"order_track_pass"];
    _lbTitle.textColor = [Utils getColorByRGB:TITLE_COLOR];
    _lbDate.hidden = NO;
    _btnOk.hidden = NO;
    _btnCancel.hidden = YES;
    
    _btnOk.enabled = NO;
    _btnOk.backgroundColor = [UIColor grayColor];
    if (pass)
    {
        [_btnOk setTitle:@"订单已确认" forState:UIControlStateNormal];
    }
    else
    {
        [_btnOk setTitle:@"订单已拒绝" forState:UIControlStateNormal];
    }
}

@end
