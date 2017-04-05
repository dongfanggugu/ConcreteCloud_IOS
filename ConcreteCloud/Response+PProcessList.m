//
//  Response+PProcessList.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/7.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Response+PProcessList.h"

@implementation ResponseDictionary(PProcessList)

- (PProcessList *)getProcessList:(NSDictionary *)body
{
    self.body = body;
    return [[PProcessList alloc] initWithDictionary:body];
}

@end
