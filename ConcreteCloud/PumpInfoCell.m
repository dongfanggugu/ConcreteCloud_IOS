//
//  PumpInfoCell.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/23.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PumpInfoCell.h"

@interface PumpInfoCell()

@end


@implementation PumpInfoCell

+ (id)cellFromView
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PumpInfoCell" owner:nil options:nil];
    
    if (0 == array.count)
    {
        return nil;
    }
    
    return array[0];
}

+ (CGFloat)cellHeight
{
    return 84;
}

+ (NSString *)identifier
{
    return @"pump_info_cell";
}

@end
