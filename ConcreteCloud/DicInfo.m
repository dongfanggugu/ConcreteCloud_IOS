//
//  DicInfo.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/13.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DicInfo.h"

@implementation DicInfo

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self) {
        self.dicId = [dictionary objectForKey:@"id"];
        
        if (!self.name) {
            self.name = dictionary[@"pricingName"];
        }
        
        if (!self.value) {
            self.value = dictionary[@"pricingItem"];
        }
        
        if (!self.type) {
            self.type = dictionary[@"pricingType"];
        }
    }
    
    return self;
}

#pragma mark - ListDialogDataDelegate

- (NSString *)getKey
{
    return _dicId;
}

- (NSString *)getShowContent
{
    return _value;
}

@end
