//
//  ProjectView.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/15.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProjectView.h"

@interface ProjectView()

@end

@implementation ProjectView


+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ProjectView" owner:nil options:nil];
    
    if (0 == array.count)
    {
        return nil;
    }
    
    return array[0];
}

@end
