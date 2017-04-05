//
//  DicResponse.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/13.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DicResponse.h"
#import "DicInfo.h"

@implementation DicResponse

+ (Class)body_class
{
    return [DicInfo class];
}

@end
