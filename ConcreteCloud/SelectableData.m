//
//  SelectableData.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/23.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SelectableData.h"

@interface SelectableData()
{
    NSString *_key;
    
    NSString *_content;
}

@end

@implementation SelectableData

- (id)initWithKey:(NSString *)key content:(NSString *)content
{
    self = [super init];
    if (self)
    {
        _key = key;
        _content = content;
    }
    
    return self;
}

- (NSString *)getKey
{
    return _key;
}

- (NSString *)getShowContent
{
    return _content;
}

@end
