//
//  MessageInfo.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/5.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageInfo.h"

@implementation MessageInfo

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self)
    {
        self.msgId = [dictionary objectForKey:@"id"];
    }
    
    return self;
}

@end
