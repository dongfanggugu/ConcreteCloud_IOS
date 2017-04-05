//
//  VideoListResponse.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/28.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoListResponse.h"

@implementation VideoListResponse

+ (Class)body_class
{
    return [VideoInfo class];
}

- (NSArray<VideoInfo *> *)getVideoList
{
    return (NSArray<VideoInfo *> *)self.body;
}

@end
