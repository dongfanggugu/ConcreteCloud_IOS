//
//  DOrderDetailCell1.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/17.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DOrderDetailCell1.h"

@interface DOrderDetailCell1()

@end

@implementation DOrderDetailCell1

+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"DOrderDetailCell1" owner:nil options:nil];
    
    if (0 == array.count)
    {
        return nil;
    }
    
    return array[0];
}

+ (CGFloat)cellHeight
{
    return 124;
}


@end
