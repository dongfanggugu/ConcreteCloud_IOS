//
//  TaluoduDivInfo.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/22.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaluoduDivInfo.h"

@implementation TaluoduDivInfo

- (id)initWithKey:(NSString *)key content:(NSString *)content
{
    self = [super init];
    
    if (self)
    {
        self.key = key;
        self.content = content;
    }
    
    return self;
}

- (NSString *)getShowContent
{
    return _content;
}

- (NSString *)getKey
{
    return _key;
}

@end
