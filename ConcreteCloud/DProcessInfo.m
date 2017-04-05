//
//  DProcessInfo.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DProcessInfo.h"

@implementation DProcessInfo

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self)
    {
        self.processId = dictionary[@"id"];
    }
    
    return self;
}

@end
