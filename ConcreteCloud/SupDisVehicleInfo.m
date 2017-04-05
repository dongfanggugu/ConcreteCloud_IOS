//
//  SupDisVehicleInfo.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/15.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupDisVehicleInfo.h"

@implementation SupDisVehicleInfo

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self)
    {
        self.vehicleId = dictionary[@"id"];
    }
    
    return self;
}

@end
