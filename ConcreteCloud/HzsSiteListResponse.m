//
//  HzsSiteListResponse.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/22.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HzsSiteListResponse.h"

@implementation HzsSiteListResponse


- (HzsSiteListInfo *)getHzsSiteInfo
{
    return [[HzsSiteListInfo alloc] initWithDictionary:self.body];
}

@end
