//
//  SProcess2Cell.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/22.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SProcess2Cell.h"

@interface SProcess2Cell()

@property (weak, nonatomic) IBOutlet UIImageView *ivProcess;

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

@end

@implementation SProcess2Cell

+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SProcess2Cell" owner:nil options:nil];
    
    if (0 == array.count)
    {
        return nil;
    }
    
    return array[0];
}


+ (NSString *)identifier
{
    return @"s_process2_cell";
}

+ (CGFloat)cellHeight
{
    return 108;
}


- (void)setFutureMode
{
    _ivProcess.image = [UIImage imageNamed:@"order_track_future"];
    _lbTitle.textColor = [UIColor grayColor];
    _lbDate.hidden = YES;
    _lbTip.hidden = YES;
    _lbConfirmUser.hidden = YES;
    _lbTel.hidden = YES;
    
}

- (void)setCurrentMode
{
    _ivProcess.image = [UIImage imageNamed:@"order_track_current"];
    _lbTitle.textColor = [Utils getColorByRGB:TITLE_COLOR];
    _lbDate.hidden = NO;
    _lbTip.hidden = NO;
    _lbConfirmUser.hidden = NO;
    _lbTel.hidden = NO;
}

- (void)setPassMode
{
    _ivProcess.image = [UIImage imageNamed:@"order_track_pass"];
    _lbTitle.textColor = [Utils getColorByRGB:TITLE_COLOR];
    _lbDate.hidden = NO;
    _lbTip.hidden = NO;
    _lbConfirmUser.hidden = NO;
    _lbTel.hidden = NO;
}

@end

