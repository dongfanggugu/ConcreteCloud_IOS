//
//  RentBindRequest.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/9.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RentBindRequest.h"

@implementation RentBindRequest

- (NSDictionary *)parsToDictionary
{
    NSMutableDictionary *dic = [[super parsToDictionary] mutableCopy];
    
    dic[@"id"] = self.vehicelId;
    
    return [dic copy];
}

@end

