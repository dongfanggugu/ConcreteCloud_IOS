//
//  RenterListResponse.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RenterListResponse.h"

@implementation RenterListResponse

- (NSArray<RenterInfo *> *)getRenterList
{
    return (NSArray<RenterInfo *> *)self.body;
}

+ (Class)body_class
{
    return [RenterInfo class];
}

@end
