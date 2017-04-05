//
//  PProcess2Cell.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/1/20.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PProcess2Cell.h"

@interface PProcess2Cell()

@property (weak, nonatomic) IBOutlet UILabel *lbNameKey;

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

@property (weak, nonatomic) IBOutlet UIImageView *ivProcess;

@end


@implementation PProcess2Cell

+ (instancetype)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PProcess2Cell" owner:nil options:nil];
    
    if (0 == array)
    {
        return nil;
    }
    
    return array[0];
}

+ (NSString *)identifier
{
    return @"p_process2_cell";
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
    _lbNameKey.hidden = YES;
    _lbName.hidden = YES;
    _lbTel.hidden = YES;
    _lbTip.hidden = YES;
}

- (void)setCurrentMode
{
    _ivProcess.image = [UIImage imageNamed:@"order_track_current"];
    _lbTitle.textColor = [Utils getColorByRGB:TITLE_COLOR];
    _lbDate.hidden = NO;
    _lbNameKey.hidden = NO;
    _lbName.hidden = NO;
    _lbTel.hidden = NO;
    _lbTip.hidden = NO;
}

- (void)setPassMode
{
    _ivProcess.image = [UIImage imageNamed:@"order_track_pass"];
    _lbTitle.textColor = [Utils getColorByRGB:TITLE_COLOR];
    _lbDate.hidden = NO;
    _lbNameKey.hidden = NO;
    _lbName.hidden = NO;
    _lbTel.hidden = NO;
    _lbTip.hidden = NO;
}

@end
