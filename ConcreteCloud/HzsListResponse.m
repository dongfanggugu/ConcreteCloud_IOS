//
//  HzsListResponse.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/21.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HzsListResponse.h"

@implementation HzsListResponse

+ (Class)body_class
{
    return [HzsInfo class];
}
- (NSArray<HzsInfo *> *)getHzsList
{
    return (NSArray<HzsInfo *> *)self.body;
}

@end