//
//  SelVehicleResponse.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/15.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SelVehicleResponse.h"

@implementation SelVehicleResponse

+ (Class)body_class
{
    return [SelVehicleInfo class];
}

- (NSArray<SelVehicleInfo *> *)getSelVehicles
{
    return (NSArray<SelVehicleInfo *> *)self.body;
}

@end
