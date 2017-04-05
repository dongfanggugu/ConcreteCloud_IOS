//
//  RenterView.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/20.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RenterView.h"

@interface RenterView()

@end

@implementation RenterView

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RenterView" owner:nil options:nil];
    
    if (0 == array.count)
    {
        return nil;
    }
    
    return array[0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _lbRenter.layer.masksToBounds = YES;
    _lbRenter.layer.cornerRadius = 8;
    
    self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
}

@end
