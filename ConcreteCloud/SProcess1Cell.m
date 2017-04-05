//
//  SProcess1Cell.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/21.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SProcess1Cell.h"


@interface SProcess1Cell()

@property (weak, nonatomic) IBOutlet UIImageView *ivProcess;

@property (weak, nonatomic) IBOutlet UILabel *lbTip;

@end


@implementation SProcess1Cell

+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SProcess1Cell" owner:nil options:nil];
    
    if (0 == array.count)
    {
        return nil;
    }
    
    return array[0];
}

+ (CGFloat)cellHeight
{
    return 80;
}

+ (NSString *)identifier
{
    return @"s_process1_cell";
}

- (void)setCurrentMode
{
    _ivProcess.image = [UIImage imageNamed:@"order_track_current"];
    
    _lbTip.text = @"请耐心等待搅拌站确认";
}

- (void)setPassMode
{
    _ivProcess.image = [UIImage imageNamed:@"order_track_pass"];
    
    _lbTip.text = @"搅拌站已经处理";

}

@end
