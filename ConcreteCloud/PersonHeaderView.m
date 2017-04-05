//
//  PersonHeaderView.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/8.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersonHeaderView.h"

@interface PersonHeaderView()

@end

@implementation PersonHeaderView

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PersonHeaderView" owner:nil options:nil];
    
    if (0 == array.count)
    {
        return nil;
    }
    
    return array[0];
}

@end
