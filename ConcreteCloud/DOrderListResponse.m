//
//  DOrderListResponse.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DOrderListResponse.h"

@implementation DOrderListResponse

- (NSArray<DOrderInfo *> *)getOrderList
{
    return (NSArray<DOrderInfo *> *)self.body;
}

+ (Class)body_class
{
    return [DOrderInfo class];
}


@end
