//
//  ACheckListResponse.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/24.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACheckListResponse.h"

@implementation ACheckListResponse

+ (Class)body_class
{
    return [DTrackInfo class];
}

- (NSArray<DTrackInfo *> *)getCheckList
{
    return (NSArray<DTrackInfo *> *)self.body;
}

@end
