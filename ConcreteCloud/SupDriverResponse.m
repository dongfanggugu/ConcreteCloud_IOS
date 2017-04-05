//
//  SupDriverResponse.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/15.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupDriverResponse.h"

@implementation SupDriverResponse

+ (Class)body_class
{
    return [SupDriverInfo class];
}

- (NSArray<SupDriverInfo *> *)getSupDrivers
{
    return (NSArray<SupDriverInfo *> *)self.body;
}

@end
