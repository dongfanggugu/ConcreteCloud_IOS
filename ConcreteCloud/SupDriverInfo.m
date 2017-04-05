//
//  SupDriverInfo.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/15.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupDriverInfo.h"

@implementation SupDriverInfo

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self)
    {
        self.driverId = dictionary[@"id"];
    }
    
    return self;
}

- (NSString *)getKey
{
    return self.driverId;
}

- (NSString *)getShowContent
{
    return self.name;
}

@end
