//
//  SupDisVehicleResponse.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/15.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupDisVehicleResponse.h"

@implementation SupDisVehicleResponse

+ (Class)body_class
{
    return [SupDisVehicleInfo class];
}

- (NSArray<SupDisVehicleInfo *> *)getVehicles
{
    return (NSArray<SupDisVehicleInfo *> *)self.body;
}

@end
