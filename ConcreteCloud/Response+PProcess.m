//
//  Response+PProcess.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/1/23.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Response+PProcess.h"

@implementation ResponseDictionary(PProcess)

- (PProcessData *)getPProcessData:(NSDictionary *)body
{
    self.body = body;
    return [[PProcessData alloc] initWithDictionary:body];
}

@end
