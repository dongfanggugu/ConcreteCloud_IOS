//
//  MsgTypeInfo.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MsgTypeInfo.h"

@implementation MsgTypeInfo

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self)
    {
        self.msgId = [dictionary objectForKey:@"id"];
        self.des = [dictionary objectForKey:@"description"];
    }
    
    return self;
}

@end
