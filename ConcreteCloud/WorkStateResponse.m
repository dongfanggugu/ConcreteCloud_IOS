//
//  WorkStateResponse.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/28.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WorkStateResponse.h"

@implementation WorkStateResponse

- (NSString *)getState
{
    return [self.body objectForKey:@"state"];
}

@end
