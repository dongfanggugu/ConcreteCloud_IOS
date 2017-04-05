//
//  Response+POrderInfo.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/1/22.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Response+POrderInfo.h"

@implementation ResponseDictionary(POrderInfo)

- (POrderInfo *)pOrderInfo:(NSDictionary *)body
{
    self.body = body;
    return [[POrderInfo alloc] initWithDictionary:body];
}

@end
