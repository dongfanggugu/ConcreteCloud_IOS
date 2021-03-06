//
//  PTrackInfo.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/7.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTrackInfo.h"

@implementation PTrackInfo

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self) {
        
        if (!self.processId) {
            self.processId = dictionary[@"id"];
        }
    }
    
    return self;
}


@end
