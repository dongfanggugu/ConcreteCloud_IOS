//
//  SPumpListResponse.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/24.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPumpListResponse.h"

@implementation SPumpListResponse

+ (Class)body_class
{
    return [DTrackInfo class];
}

- (NSArray<DTrackInfo *> *)getPumpList
{
    return (NSArray<DTrackInfo *> *)self.body;
}

@end
