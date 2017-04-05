//
//  PStatisticsRequest.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/8.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PStatisticsRequest.h"

@implementation PStatisticsRequest

- (NSDictionary *)parsToDictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[super parsToDictionary]];
    
    [dic setObject:_branchId forKey:@"id"];
    
    return [dic copy];
    
}

@end