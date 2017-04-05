//
//  RentVehicleInfo.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/20.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RentVehicleInfo.h"

@implementation RentVehicleInfo

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self)
    {
        NSDictionary *addtional = dictionary[@"additionalInfo"];
    
        self.additionalInfo = [[AddtionalVehicleInfo alloc] initWithDictionary:addtional];
        
        self.vehicleId = dictionary[@"id"];
    }
    
    return self;
}

@end
