//
//  SupOrderCell1.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/14.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupOrderCell1.h"

@implementation SupOrderCell1

+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SupOrderCell1" owner:nil options:nil];
    
    if (0 == array.count)
    {
        return nil;
    }
    
    return array[0];
}

+ (NSString *)identifier
{
    return @"sup_order_cell1";
}

+ (CGFloat)cellHeight
{
    return 88;
}

@end
