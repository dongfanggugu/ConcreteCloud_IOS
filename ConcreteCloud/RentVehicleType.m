//
//  RentVehicleType.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/20.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RentVehicleType.h"

@implementation RentVehicleType

- (id)initWithKey:(NSString *)key content:(NSString *)content
{
    self = [super init];
    
    if (self)
    {
        self.key = key;
        self.showContent = content;
    }
    
    return self;
}

- (NSString *)getKey
{
    return _key;
}

- (NSString *)getShowContent
{
    return _showContent;
}
@end
