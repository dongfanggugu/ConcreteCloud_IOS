//
//  SupStartUpRequest.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/14.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupStartUpRequest.h"

@implementation SupStartUpRequest

- (NSDictionary *)parsToDictionary
{
    NSMutableDictionary *dic = [[super parsToDictionary] mutableCopy];
    dic[@"id"] = self.taskId;
    
    return [dic copy];
}

@end
