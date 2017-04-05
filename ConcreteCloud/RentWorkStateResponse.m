//
//  RentWorkStateResponse.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/10.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RentWorkStateResponse.h"

@implementation RentWorkStateResponse

- (RentVehicleInfo *)getVehicleInfo
{
    if (!self.body)
    {
        return nil;
    }
    
    if ([self.body isEqual:@"{}"])
    {
        return nil;
    }

    return [[RentVehicleInfo alloc] initWithDictionary:self.body];    
}

@end
