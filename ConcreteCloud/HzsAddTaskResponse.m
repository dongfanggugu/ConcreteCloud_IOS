//
//  HzsAddTaskResponse.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/1.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HzsAddTaskResponse.h"

@implementation HzsAddTaskResponse

- (DTrackInfo *)getHzsTask
{
    return [[DTrackInfo alloc] initWithDictionary:self.body];
}

@end