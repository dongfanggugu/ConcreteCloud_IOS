//
//  SupDriverHistoryResponse.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/14.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupDriverHistoryResponse.h"

@implementation SupDriverHistoryResponse

+ (Class)body_class
{
    return [PTrackInfo class];
}

- (NSArray<PTrackInfo *> *)getTask
{
    return (NSArray<PTrackInfo *> *)self.body;
}

@end
