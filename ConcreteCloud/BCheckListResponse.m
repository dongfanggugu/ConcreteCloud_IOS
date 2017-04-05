//
//  BCheckListResponse.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCheckListResponse.h"

@implementation BCheckListResponse

+ (Class)body_class
{
    return [PTrackInfo class];
}

- (NSArray<PTrackInfo *> *)getCheckList
{
    return (NSArray<PTrackInfo *> *)self.body;
}

@end
