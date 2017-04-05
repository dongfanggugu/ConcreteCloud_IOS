//
//  RentVehicleInfoCell.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/13.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RentVehicleInfoCell.h"

@implementation RentVehicleInfoCell

+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RentVehicleInfoCell" owner:nil options:nil];
    
    if (0 == array.count)
    {
        return nil;
    }
    
    return array[0];
}

+ (NSString *)identifier
{
    return @"rent_vehicle_info_cell";
}

+ (CGFloat)cellHeight
{
    return 77;
}

@end