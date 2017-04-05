//
//  SupDisVehicleCell.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/15.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupDisVehicleCell.h"

@implementation SupDisVehicleCell

+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SupDisVehicleCell" owner:nil options:nil];

    if (0 == array.count)
    {
        return nil;
    }
    
    return array[0];
}

+ (NSString *)identifier
{
    return @"sup_dis_vehicle_cell";
}

+ (CGFloat)cellHeight
{
    return 150;
}


@end
