//
//  Response+VehicleTrail.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/8.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Response+VehicleTrail.h"

@implementation ResponseArray(VehicleTrail)

- (NSArray<VehicleTrailInfo *> *)getVehicleTrailArray
{
    return (NSArray<VehicleTrailInfo *> *)self.body;
}

+ (Class)body_class
{
    return [VehicleTrailInfo class];
}

@end
