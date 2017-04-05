//
//  HzsSiteListInfo.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/22.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HzsSiteListInfo.h"

@implementation HzsSiteListInfo


+ (Class)siteList_class
{
    return [ProjectInfo class];
}

+ (Class)vehicleList_class
{
    return [DTrackInfo class];
}

+ (Class)hzsList_class
{
    return [HzsInfo class];
}

+ (Class)taskList_class
{
    return [DTrackInfo class];
}


@end
