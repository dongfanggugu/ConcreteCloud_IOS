//
//  RentVehicleDelRequest.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/13.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RentVehicleDelRequest.h"

@implementation RentVehicleDelRequest

- (NSDictionary *)parsToDictionary
{
    NSMutableDictionary *dic = [[super parsToDictionary] mutableCopy];
    
    dic[@"id"] = self.vehicleId;
    
    return [dic copy];
}

@end
