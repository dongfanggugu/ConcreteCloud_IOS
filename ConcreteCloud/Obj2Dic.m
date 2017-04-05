//
//  Obj2Dic.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/14.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Obj2Dic.h"
#import <objc/runtime.h>

@implementation Obj2Dic

+ (NSDictionary *)getObjectData:(id)obj
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    unsigned int propsCount;
    
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    
    for (int i = 0; i < propsCount; i++)
    {
        objc_property_t prop = props[i];
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [obj valueForKey:propName];
        
        if (nil == value)
        {
            //value = [NSNull null];
            continue;
        }
        else
        {
            value = [self getObjectInternal:value];
        }
        
        [dic setObject:value forKey:propName];
    }
    
    return dic;
}


+ (id)getObjectInternal:(id)obj
{
    if ([obj isKindOfClass:[NSString class]]
        || [obj isKindOfClass:[NSNumber class]]
        || [obj isKindOfClass:[NSNull class]])
    {
        return obj;
    }
    
    if ([obj isKindOfClass:[NSArray class]])
    {
        NSArray *objArr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objArr.count];
        
        for (int i = 0; i < objArr.count; i++)
        {
            [arr setObject:[self getObjectInternal:[objArr objectAtIndex:i]] atIndexedSubscript:i];
        }
        
        return arr;
    }
    
    if ([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *objDic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:objDic.count];
        
        for (NSString *key in objDic.allKeys)
        {
            [dic setObject:[self getObjectInternal:[objDic objectForKey:key]] forKey:key];
        }
        
        return dic;
    }
    
    return [self getObjectData:obj];
}

+ (void)print:(id)obj
{
    NSLog(@"%@ ", [self getObjectData:obj]);
}

@end
