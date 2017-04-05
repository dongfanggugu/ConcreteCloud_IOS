//
//  POrderItemView2.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/6.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "POrderItemView2.h"

@interface POrderItemView2()

@end

@implementation POrderItemView2

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"POrderItemView2" owner:nil options:nil];
    if (0 == array)
    {
        return nil;
    }
    
    return array[0];
}

+ (CGFloat)itemHeight
{
    return 66;
}

+ (NSString *)getIdentifier
{
    return @"p_order_item2";
}

@end
