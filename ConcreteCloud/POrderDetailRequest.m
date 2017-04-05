//
//  POrderDetailRequest.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/1/22.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "POrderDetailRequest.h"

@implementation POrderDetailRequest

- (NSDictionary *)parsToDictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[super parsToDictionary]];
    
    [dic setObject:_orderId forKey:@"id"];
    
    return [dic copy];
}

@end
