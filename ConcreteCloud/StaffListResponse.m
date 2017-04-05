//
//  StaffListResponse.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/23.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StaffListResponse.h"

@implementation StaffListResponse

+ (Class)body_class
{
    return [SiteStaffInfo class];
}

- (NSArray<SiteStaffInfo *> *)getStaffList
{
    return (NSArray<SiteStaffInfo *> *)self.body;
}

@end
