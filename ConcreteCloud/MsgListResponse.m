//
//  MsgListResponse.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/6.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MsgListResponse.h"
#import "MessageInfo.h"

@implementation MsgListResponse

+ (Class)body_class
{
    return [MessageInfo class];
}

@end
