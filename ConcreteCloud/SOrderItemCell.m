//
//  SOrderItemCell.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/21.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOrderItemCell.h"

@implementation SOrderItemCell


+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SOrderItemCell" owner:nil options:nil];
    
    if (0 == array.count)
    {
        return nil;
    }
    
    return array[0];
}

+ (CGFloat)cellHeight
{
    return 83;
}

+ (NSString *)identifier
{
    return @"s_order_item_cell";
}

@end
