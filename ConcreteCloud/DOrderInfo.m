//
//  DOrderInfo.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DOrderInfo.h"

@implementation DOrderInfo

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self)
    {
        self.orderId = [dictionary objectForKey:@"id"];
    }
    
    return self;
}

- (NSMutableDictionary *)toDictionary
{
    NSMutableDictionary *dic = [super toDictionary];
    
    NSLog(@"dic:%@", dic);
    
    return [dic copy];
}

- (NSString *)getKey
{
    return _orderId;
}

- (NSString *)getShowContent
{
    return _siteName;
}

@end
