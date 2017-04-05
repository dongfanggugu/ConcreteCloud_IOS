//
//  SupplierLIstResponse.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/7.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupplierListResponse.h"
#import "SupplierInfo.h"

@implementation SupplierListResponse

+ (Class)body_class
{
    return [SupplierInfo class];
}

@end
