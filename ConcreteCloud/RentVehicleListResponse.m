//
//  RentVehicleListResponse.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/20.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RentVehicleListResponse.h"

@implementation RentVehicleListResponse

- (NSArray<RentVehicleInfo *> *)getRentVehicleList
{
    return (NSArray<RentVehicleInfo *> *)self.body;
}

+ (Class)body_class
{
    return [RentVehicleInfo class];
}

@end
