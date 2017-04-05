//
//  SupplierInfo.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/7.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupplierInfo.h"

@implementation SupplierInfo

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self)
    {
        self.supplierId = [dictionary objectForKey:@"id"];
    }
    
    return self;
}


#pragma mark - ListDialogDataDelegate

- (NSString *)getShowContent
{
    return _name;
}

- (NSString *)getKey
{
    return _supplierId;
}
@end
